---
title: Standard README.md
version: "1.0"
owner: Blair Fontaine (PLAN Agent)
status: Active
last-reviewed: "2026-02-28"
applies-to: All gautada/* repositories
review-trigger: New repo type introduced, fleet-wide process change, or feedback issue filed against this standard
exceptions: Exceptions require Adam's explicit approval and must be documented in the repo's cohort/plan/notes.md
---

# Standard README.md

This document defines the required structure and content standards for every
`README.md` file across all repositories maintained by the eureka!FARMS cohort.

Every cohort member who touches a repository is responsible for maintaining its
README against this standard. Blair Fontaine owns this document. All structural
changes to this standard flow through Blair. Adam may override any section via
a filed issue or project item in Blair's Inbox.

---

## Why This Matters

A README is the contract between a project and everyone who will ever use,
operate, or extend it — including future versions of ourselves. An incomplete
or misleading README creates confusion, breaks deployments, and costs time.
We write READMEs not for credit but for clarity.

The goal is not length. The goal is that a team member with no prior context
can read the README and be productive within 15 minutes.

---

## Required Section Order

Every `README.md` **MUST** follow this exact section order. Sections may
**NOT** be omitted — they must always appear, even if only to note that they
are not applicable (see [Omission Rules](#omission-rules)). The order must
**NEVER** change.

1. Title
2. Description
3. Badges
4. Table of Contents
5. Abstract
6. Features
7. Build
8. Install
9. Run
10. Contributing
11. Links
12. License

---

## Section Guidance

---

### 1. Title

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A single `# H1` heading — the name of the project.

**Rules:**
- Match the GitHub repository name exactly (e.g. `alpine`, not `Alpine Container` or `gautada/alpine`).
- One `# H1` only. No subtitle in the heading line.
- Do not include the org prefix (`gautada/`) in the title — that is GitHub's job.

**Template:**
```markdown
# alpine
```

**What to avoid:**
- `# gautada/alpine` — includes org prefix
- `# Alpine Base Container for Kubernetes` — editorializing in the title
- Two `# H1` headings in the same file

---

### 2. Description

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A single sentence directly under the title, in italics, explaining what the project is.

**Rules:**
- One sentence. Hard limit.
- No period at the end.
- Plain English — assume the reader has never heard of this project.
- Describe **what it is**, not how it works.
- Must match (or closely mirror) the GitHub repository description field.

**Template:**
```markdown
*Alpine Linux base container image for all eureka!FARMS downstream services*
```

**Good:**
> *Debian bookworm-slim base container with s6 init, health checks, and backup scaffolding*

**Bad:**
> *This container is built on alpine:3.22 and uses s6 as its process supervisor, and it also includes some utilities*

That's a how, not a what. And it's two sentences.

---

### 3. Badges

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A row of inline status images immediately below the description.

**Rules:**
- All badges on a single line, separated by a space.
- Always include: Build Status, Latest Image Version, License.
- Optionally include: upstream version, last commit date.
- Use [Shields.io](https://shields.io/) for consistent visual style across the fleet.
- Never badge things that are not automated — a badge that goes stale is worse than no badge.

**Standard badge set for container repos:**
```markdown
![Build](https://github.com/gautada/<repo>/actions/workflows/cicd.yaml/badge.svg)
![Version](https://img.shields.io/github/v/tag/gautada/<repo>?label=version&sort=semver)
![License](https://img.shields.io/github/license/gautada/<repo>)
```

Replace `<repo>` with the repository name. This is the same set for every repo in the fleet.

---

### 4. Table of Contents

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A list of anchor-linked jump targets for every section in the README.

**Rules:**
- Required for all fleet READMEs — no exceptions.
- Must follow the standard section order defined above.
- Use GitHub-compatible anchor syntax: lowercase, spaces become `-`, punctuation dropped.
- If a section is marked N/A, still include it in the ToC so readers know it was considered.

**Template:**
```markdown
## Table of Contents
- [Abstract](#abstract)
- [Features](#features)
- [Build](#build)
- [Install](#install)
- [Run](#run)
- [Contributing](#contributing)
- [Links](#links)
- [License](#license)
```

---

### 5. Abstract

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A detailed prose explanation of the project — what it does, why it exists,
who it serves, and what it does *not* do.

**Rules:**
- 2–5 paragraphs of well-structured prose. This is not a bullet list.
- Answer four questions: What is it? Why does it exist? Who uses it? What does it not do?
- Reference upstream projects by name and link.
- For base images: describe what downstream containers inherit.
- For application containers: describe the service and its role in the fleet.
- Document current state, not aspirational state.

**Template:**
```markdown
## Abstract

`alpine` is the foundation layer for every container in the eureka!FARMS fleet.
It extends the official [Alpine Linux](https://alpinelinux.org) image with a
standardized init pattern, volume layout, health probe scaffolding, and privilege
conventions that every downstream container relies on.

This image is not intended for direct deployment. It exists so that downstream
container authors start from a known, tested, consistent base rather than
reinventing init and health check logic in every repo.

Out of scope: application-specific configuration, service definitions, or
business logic. Those belong in downstream images.
```

---

### 6. Features

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A concise bulleted list of what this project provides.

**Rules:**
- Bullets only. No paragraphs, no nested sub-bullets.
- Max 10 items. More than 10 means you are listing implementation details, not features.
- Start each bullet with a noun or verb. Be specific.
- Focus on outcomes for the user/operator, not implementation choices.

**Template:**
```markdown
## Features

- Standardized volume layout (`/mnt/volumes/{data,configmaps,backup,secrets}`)
- s6-based process supervision with drop-in service definitions
- Health probe fan-out (`liveness`, `readiness`, `startup`, `test` via single script)
- Hourly backup hook with override contract for downstream containers
- Least-privilege user model with `privileged` group and sudoers scaffolding
- Configurable timezone (default: `America/New_York`)
```

**Bad:**
> - Uses Alpine Linux 3.22
> - Has a Containerfile
> - Installs packages

Those are implementation facts, not features.

---

### 7. Build

**Owner:** Dev Makhija (CHANGE Agent)  
**What it is:** Step-by-step instructions to build the container image locally.

Dev Makhija owns the content of this section. Dev runs the CI/CD pipeline and
is the authoritative source for what is required to build each repo. The
instructions here must reflect what a human can follow to reproduce the CI build
locally — no divergence between local and CI.

**Rules:**
- Every command must be copy-pasteable as written.
- Include all required build args with their defaults shown.
- Show the exact `podman build` command used in CI.
- State prerequisites (Podman version, network requirements, etc.) explicitly.
- Do not skip steps because they seem obvious.

**Template:**
```markdown
## Build

**Prerequisites:** Podman 5+, internet access

```bash
# Standard build
podman build -t gautada/alpine:dev .

# Build with custom user
podman build \
  --build-arg USER=myapp \
  --build-arg UID=1000 \
  --build-arg GID=1000 \
  -t gautada/alpine:dev .

# Confirm the built version
podman run --rm gautada/alpine:dev /usr/bin/container-version
```
```

---

### 8. Install

**Owner:** Ren Nakatomi (SUPPORT Agent)  
**What it is:** Instructions for deploying the container into the target environment (Kubernetes / MicroK8s).

Ren Nakatomi owns the content of this section. Ren operates the production
environment and is responsible for keeping these instructions accurate and
verified against the live cluster.

**Rules:**
- This section covers *deployment*, not local development setup (that is Run).
- Show the exact commands to apply manifests or deploy the image.
- Include verification steps — how does the operator confirm the install succeeded?
- Reference required secrets and configmaps by name only — never by value.
- If this image is not deployed directly (e.g. a base image), state that explicitly.

**Template (base image — not deployed directly):**
```markdown
## Install

> `alpine` is a base image and is not deployed directly.
> See downstream container repositories for deployment instructions.
```

**Template (deployable service):**
```markdown
## Install

```bash
# Apply all manifests
kubectl apply -f k8s/

# Verify the pod is running
kubectl get pods -l app=postgresql

# Confirm health checks pass
kubectl exec -it $(kubectl get pod -l app=postgresql -o name) \
  -- /usr/bin/container-health
```

**Required secrets** (must exist in the namespace before deployment):

| Secret name | Key | Description |
| --- | --- | --- |
| `postgresql-secret` | `POSTGRES_PASSWORD` | Database superuser password |
```
```

---

### 9. Run

**Owner:** Ren Nakatomi (SUPPORT Agent)  
**What it is:** How to run the container locally for development or ad-hoc use.

Ren Nakatomi owns the content of this section. The repo must contain all
required default files and configurations — provided by Nyx Calder (DEVELOPMENT
Agent) — so that Ren can document and verify a working local run without
additional setup.

**Rules:**
- Cover the most common use case first.
- Always include the interactive shell invocation — it is always useful for debugging.
- Show volume mount conventions using the standard `/mnt/volumes/*` paths.
- Show how to exec into a running container.
- Note any required external services (databases, secret stores, etc.).

**Template:**
```markdown
## Run

```bash
# Interactive shell
podman run --rm -it gautada/alpine:dev /bin/zsh

# Run with standard volumes
podman run -d --name alpine \
  -v ./data:/mnt/volumes/data \
  -v ./config:/mnt/volumes/configmaps:ro \
  -v ./secrets:/mnt/volumes/secrets:ro \
  -v ./backup:/mnt/volumes/backup \
  gautada/alpine:dev

# Exec into running container
podman exec -it alpine /bin/zsh

# Run health check
podman exec alpine /usr/bin/container-health
```
```

---

### 10. Contributing

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** Instructions for how a team member or external contributor submits a change.

**Rules:**
- This section is never omitted. Every repo gets a Contributing section.
- Document the branch model: `dev` is the integration branch; `main` tracks releases.
- Describe the PR process — who reviews, what CI must pass.
- `plan/*` branches are the mechanism for README and documentation work.
- Dev Makhija's CI/CD pipeline gates all merges.

**Template:**
```markdown
## Contributing

This repository is actively developed and maintained by the
[eureka!FARMS cohort](https://github.com/gautada/eurekafarms) — a team of
human and AI contributors. Work is coordinated through the
[project board](https://github.com/users/gautada/projects/2).

All changes flow through `dev` before merging to `main`.

**Branch naming:**

| Type | Pattern | Example |
| --- | --- | --- |
| Feature / fix | `feature/<slug>` | `feature/fix-health-probe` |
| Documentation / README | `plan/<slug>` | `plan/readme-refresh` |
| Hotfix | `hotfix/<slug>` | `hotfix/cron-crash` |

**Process:**
1. Branch from `dev`.
2. Make changes and test locally (`podman build` + health check pass).
3. Push and open a PR targeting `dev`, assigned to Adam.
4. CI must pass — Dev Makhija's pipeline gates the merge.
5. Adam approves and merges to `dev`; `main` is updated on release.

README changes are owned by Blair Fontaine and must follow the
[README standard](https://github.com/gautada/eurekafarms/blob/main/standards/readme.md).
```

---

### 11. Links

**Owner:** Blair Fontaine (PLAN Agent)  
**What it is:** A curated list of external references relevant to this project.

Blair maintains this section and uses it to monitor upstream projects, track
release activity, and surface relevant resources when building the planning
roadmap for each repo.

**Rules:**
- Always include: upstream project, Docker Hub page, GitHub source.
- Add any documentation, community, or reference links that aid operation.
- Do not include internal Slack links, local IP addresses, or credential references.
- Keep it to 4–8 links. More than that and it becomes noise.
- Verify links are live when updating. Dead links are removed immediately.

**Template:**
```markdown
## Links

- [Alpine Linux](https://alpinelinux.org) — upstream OS
- [Docker Hub](https://hub.docker.com/r/gautada/alpine) — published images
- [GitHub](https://github.com/gautada/alpine) — source
- [s6 Overlay](https://github.com/just-containers/s6-overlay) — init system reference
- [eureka!FARMS Project Board](https://github.com/users/gautada/projects/2) — active work
```

---

### 12. License

**Owner:** Blair Fontaine (PLAN Agent); Adam may override.  
**What it is:** The license governing use and distribution of this project.

**Rules:**
- One line, linking to the `LICENSE` file in the repo.
- Include the license type in the text.
- If the project wraps or extends an upstream project (e.g. a container built on Alpine),
  use the upstream license and link to it.
- If there is no upstream project, use the most permissive open-source license appropriate
  (default: MIT).
- If the upstream license cannot be determined, Blair files a bug assigned to Adam to resolve.

**Template:**
```markdown
## License

[MIT](./LICENSE) — upstream [Alpine Linux](https://alpinelinux.org/about/) is licensed separately.
```

---

## Omission Rules

Every section must appear in every README. If a section is not applicable to a
specific repo, it must still be present — marked with a one-line N/A note explaining
why. Silently skipping a section signals neglect, not intent.

**Format for a non-applicable section:**
```markdown
## Install

> N/A — `alpine` is a base image and is not deployed directly.
```

**When sections may be marked N/A:**

| Section | May be marked N/A when... |
| --- | --- |
| Build | Image is not built from source in this repo |
| Install | This is a base image not deployed directly |
| Run | Same conditions as Install |
| Contributing | Never — this section is always present with full content |

If Adam believes a section was incorrectly marked N/A, a bug is filed against
the repo and assigned to Blair for resolution.

---

## README Quality Checklist

Before committing any README update, verify:

- [ ] All 12 sections present (or marked N/A per Omission Rules)
- [ ] Frontmatter present and accurate in `standards/readme.md` (this file only)
- [ ] Description is one sentence, no period, matches GitHub repository description field
- [ ] All badges link correctly and reflect live automated state
- [ ] Every code block is copy-pasteable and has been tested
- [ ] No placeholder text (`TODO`, `TBD`, `insert here`) remains
- [ ] Build and Run sections match what CI actually does
- [ ] Contributing section references the `dev` branch, PR process, and eureka!FARMS cohort
- [ ] Links section verified — no dead links
- [ ] License reflects upstream project license (or MIT if no upstream)

---

## Maintenance

| Responsibility | Owner |
| --- | --- |
| This standard document | Blair Fontaine (PLAN Agent) |
| Build section content per repo | Dev Makhija (CHANGE Agent) |
| Install + Run section content per repo | Ren Nakatomi (SUPPORT Agent) |
| All other sections per repo | Blair Fontaine (PLAN Agent) |
| Override authority | Adam Gautier |

**Feedback process:** Adam files a project item in Blair's Inbox with notes or
corrections. Blair makes all edits to this document. Changes take effect
immediately upon merge to `main`.
