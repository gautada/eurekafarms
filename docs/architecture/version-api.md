# Version API Server — Design

> Issue: [#41](https://github.com/gautada/eurekafarms/issues/41)

## Problem

Build scripts resolve upstream release versions at build time by hitting provider APIs (primarily GitHub Releases). When those calls encounter rate limits, CI fails even though the codebase is healthy. We need a central service that caches release metadata and shields builds from transient rate limiting.

## Goals

- Provide a single endpoint the build pipeline can query for “latest” (or pinned) release info.
- Cache GitHub release metadata with configurable TTLs and background refresh so builds rarely touch the GitHub API directly.
- Offer an HTTP interface that returns deterministic JSON for scripts and can fall back to GitHub if cache misses happen.
- Ship as a container that fits into the existing `gautada/debian` stack with observability hooks.

### Non-goals

- Implementing the actual deployment in this issue (that will be a follow-up run task).
- Rewriting every consumer script. Each repo will opt-in by pointing its helper script to the new API.

## Architecture Overview

```
Build job (curl)
      │
      ▼
Version API Service  ──────► Redis cache (tag + metadata)
      │                        │
      └──────(on miss)─────────┘
                 │
                 ▼
            GitHub REST API
```

Components:
- **API Service** — FastAPI (Python) or Fiber (Go) app exposing `/v1/github/latest-release/{owner}/{repo}`.
- **Cache store** — Redis (managed or container) storing JSON blobs keyed by `github:<owner>/<repo>:channel`.
- **Refresher** — background task that periodically refreshes “hot” repos and records ETags to minimize API quota usage.

## API Surface

`GET /v1/github/latest-release/{owner}/{repo}`
- **Query params**
  - `channel`: `stable` (default) or `prerelease`
  - `force_refresh`: optional flag to bypass cache (auth required)
- **Response**
```json
{
  "owner": "sosedoff",
  "repo": "pgweb",
  "tag": "v0.17.0",
  "published_at": "2024-12-04T22:11:00Z",
  "assets": [
    {"name": "pgweb_linux_amd64", "browser_download_url": "https://..."}
  ],
  "source_tarball": "https://api.github.com/repos/.../tarball/v0.17.0",
  "source_zipball": "https://api.github.com/repos/.../zipball/v0.17.0"
}
```
- **Error codes**
  - `404` if the repo has no releases
  - `429` if both cache and GitHub fail due to rate limiting (includes retry-after hint)
  - `502` if GitHub returns an unexpected error (build scripts can fall back to direct call)

## Caching Strategy

- Redis TTL default: 6 hours (configurable).
- Store GitHub ETag + `last_checked` to support conditional requests and reduce quota consumption.
- Background refresher checks the most-requested repos every hour and refreshes stale entries asynchronously.
- Cache entries include a `fetched_from` field (`cache` or `github`) for observability.

## Build Integration

1. Helper scripts in each container call the Version API first:
   ```bash
   VERSION=$(curl -sf https://version-api.internal/v1/github/latest-release/sosedoff/pgweb | jq -r '.tag')
   ```
2. If the API call fails with `502/429`, the script falls back to the existing GitHub request.
3. Long term we can remove the fallback once confidence is high.

## Deployment Plan

- New repo: `gautada/version-api` (FastAPI + Redis client + container artifacts).
- Container: multi-stage build on `gautada/debian`, includes uvicorn + gunicorn.
- Configuration via environment variables:
  - `GITHUB_TOKEN` (PAT dedicated to this service)
  - `REDIS_URL`
  - `DEFAULT_TTL_SECONDS`
- Deploy as a small Deployment in the cluster with an internal-only Service (`version-api.internal.svc.cluster.local`).
- Monitoring: expose Prometheus metrics (`/metrics`) for cache hit rate, GitHub call count, rate-limit headroom.

## Stretch: Other Source Support

Design the cache key and provider abstraction so we can add modules later:
- `pypi:<package>` — queries PyPI JSON API and caches `info.version`.
- `npm:<package>` — queries NPM registry for `dist-tags.latest`.
- Each provider implements `fetch_latest()` + `serialize()`; API route dispatches based on `provider` path segment (`/v1/{provider}/latest`).

## Next Steps / Risks

- Implementation + repo scaffolding (new issue).
- Provision Redis (existing infra or managed service) and decide on HA requirements.
- Update consumer build scripts (`version.sh`, etc.) to call the API.
- Ensure GitHub token for the service has low privileges (read-only public_repo scope works).
