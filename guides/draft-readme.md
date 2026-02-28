---
title: Standard README.md
owner: PLAN Agent
review: This guide is reviewed when a new repo type is introduced or when the fleet-wide process changes.
exceptions: Exceptions to this standard require Adam's explicit approval and must be documented in the repo's `cohort/plan/notes.md`.
---

# Standard README.md
  
This document defines the required structure and content standards for every `README.md` file for all repositories being reviewed by the eureka!FARMS cohort.

---

## Why This Matters

A README is the contract between a project and everyone who will ever use, operate, or extend it — including future versions of ourselves. An incomplete or misleading README creates confusion, breaks deployments, and costs time. We write READMEs not for credit but for clarity.

The goal is not length. The goal is that a team member with no prior context can read the README and be productive within 15 minutes.

---

## Required Section Order

Every `README.md` **MUST** follow this exact section order. Sections may **NOT** be omitted but marked as not applicable. The order must **NEVER** change.

1. Title
2. Description
3. Badges
4. Table of Contents
5. Abstract
6. Features
- Roadmap REMOVE THIS SECTION.
8. Build
9. Install
10. Run
11. Contributing
12. Links
13. License

---

## Section Guidance

---

### 1. Title

**What it is:** A single `# H1` heading. The name of the project.

**Rules:**
- Match the GitHub repository name exactly (e.g. `alpine`, not `Alpine Container` or `gautada/alpine`).
- One `# H1` only. No subtitle in the heading line.
- Do not include the org prefix (`gautada/`) in the title — that's GitHub's job.

**Template:**
```markdown
# alpine
```

**What to avoid:**
- `# gautada/alpine` ← includes org prefix
- `# Alpine Base Container for Kubernetes` ← editorializing in the title
- `# Alpine` followed by another `# Heading` at the same level

---

### 2. Description

**What it is:** A single sentence directly under the title, in italics, that explains what the project is.

**Rules:**
- One sentence. Hard limit.
- No period at the end.
- Plain English — assume the reader has never heard of this project.
- Describe **what it is**, not how it works.
- This should match (or closely mirror) the GitHub repository description field.

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

**What it is:** A row of inline status images immediately below the description.

**Rules:**
- All badges on a single line, separated by a space.
- Always include: Build Status, Latest Image Version, License.
- Optionally include: upstream version, last commit date.
- Use [Shields.io](https://shields.io/) for consistent style across the fleet.
- Never badge things that aren't automated — a badge that goes stale is worse than no badge.

**Standard badge set for container repos:**
```markdown
![Build](https://github.com/gautada/<repo>/actions/workflows/cicd.yaml/badge.svg)
![Version](https://img.shields.io/github/v/tag/gautada/<repo>?label=version&sort=semver)
![License](https://img.shields.io/github/license/gautada/<repo>)
```

**Replace `<repo>` with the repository name for each project.**

---

### 4. Table of Contents

**What it is:** A list of anchor-linked jump targets covering every section in the README.

**Rules:**
- Required for all READMEs with more than 4 sections (i.e. all of them in this fleet).
- Must follow the standard section order defined above.
- Use GitHub-compatible anchor syntax: lowercase, spaces become `-`, punctuation dropped.
- Omit sections that aren't present in this specific README.

**Template:**
```markdown
## Table of Contents
- [Abstract](#abstract)
- [Features](#features)
- [Roadmap](#roadmap)
- [Build](#build)
- [Install](#install)
- [Run](#run)
- [Contributing](#contributing)
- [Links](#links)
- [License](#license)
```

---

### 5. Abstract

**What it is:** A detailed, prose explanation of the project — what it does, why it exists, who it serves, and what it does *not* do.

**Rules:**
- 2–5 paragraphs or well-structured prose. This is not a bullet list.
- Answer four questions: What is it? Why does it exist? Who uses it? What doesn't it do?
- Reference upstream projects by name and link.
- For base images: describe what downstream containers inherit.
- For application containers: describe the service and its role in the fleet.
- Keep it honest — document current state, not aspirational state.

**Template:**
```markdown
## Abstract

`alpine` is the foundation layer for every container in the Eureka FARMS fleet.
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

**What it is:** A concise bulleted list of what this project provides.

**Rules:**
- Bullets only. No paragraphs, no nested sub-bullets.
- Max 10 items. If you have more, you're listing implementation details, not features.
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
- UTC-configurable timezone (default: `America/New_York`)
```

**Bad:**
> - Uses Alpine Linux 3.22
> - Has a Containerfile
> - Installs packages

Those are implementation facts, not features.

---

### 8. Build

**What it is:** Step-by-step instructions to build the container image locally.  This section should be updated and maintained by the CHANGE Agent(Dev Makhija).  They run the CICD script and should follow the workflow to understand what is needed to build the repo.  This section should be the instructions that a human can follow.

**Rules:**
- Every command must be copy-pasteable as written.
- Include all required build args. Show their defaults.
- Show the exact `podman build` command used in CI so local and CI builds match.
- If there are prerequisites (specific Podman version, network access, etc.), state them.
- Do not skip steps because they seem obvious.


**Template:**
```markdown
## Build

**Prerequisites:** Podman 5+, internet access (pulls from Alpine mirrors)

```bash
# Standard build
podman build -t gautada/alpine:dev .

# Build with custom user
podman build \
  --build-arg USER=myapp \
  --build-arg UID=1000 \
  --build-arg GID=1000 \
  -t gautada/alpine:dev .

# Capture the built version
podman run --rm gautada/alpine:dev /usr/bin/container-version
```
```

---

### 9. Install

**What it is:** Instructions for deploying the container into the target environment (Kubernetes / MicroK8s).  This wull be owned by the SUPPORT Agent(Ren Nakatomi).  

**Rules:**
- This section is about *deployment*, not development setup.
- Show the exact commands to apply manifests or deploy the image.
- Include verification steps — how does the operator know the install succeeded?
- Reference required secrets/configmaps by name (never by value).
- If this image is not deployed directly (e.g. a base image), say so explicitly and skip further detail.

**Template:**
```markdown
## Install

> **Note:** `alpine` is a base image and is not deployed directly. See downstream
> containers for deployment instructions.
```

*For a deployable service (e.g. postgresql):*
```markdown
## Install

```bash
# Apply all manifests
kubectl apply -f k8s/

# Verify the pod is running
kubectl get pods -l app=postgresql

# Verify health checks pass
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

### 10. Run

**What it is:** How to run the container locally for development or ad-hoc use. Again this should documentation be completed by the SUPPORT Agent.  The repo should contain all the required default files and configurations needed (provided by the DEVELOPMENT Agent[Nyx Calder]) to perform an adhoc run.  Again the contents in the section should be provided by Ren Nakatomi the SUPPORT Agent. 

**Rules:**
- Cover the most common use case first.
- Include the interactive shell invocation — always useful for debugging.
- Show volume mount conventions.
- Show how to exec into a running container.
- If the container requires external services (a database, a secret store), note it.

**Template:**
```markdown
## Run

```bash
# Run with interactive shell
podman run --rm -it gautada/alpine:dev /bin/zsh

# Run with standard volumes mounted
podman run -d --name alpine \
  -v ./data:/mnt/volumes/data \
  -v ./config:/mnt/volumes/configmaps:ro \
  -v ./secrets:/mnt/volumes/secrets:ro \
  -v ./backup:/mnt/volumes/backup \
  gautada/alpine:dev

# Exec into a running container
podman exec -it alpine /bin/zsh

# Check health
podman exec alpine /usr/bin/container-health
```
```

---

### 11. Contributing

**What it is:** Instructions for how a team member or external contributor submits a change.  This needs to express the that the project is being actively developed and maintained by AI.  Instructions should take this into account.  This section should be maintained by the PLANNING AGENT (Blair)

**Rules:**
- This is not optional. Every repo gets a Contributing section.
- Document the branch model: `dev` is the integration branch; `main` tracks releases.
- Describe the PR process — who reviews, what CI must pass.
- Reference `plan/*` branches as the mechanism for README/docs work.
- Reference Dev Makhija's CI/CD review gate.

**Template:**
```markdown
## Contributing

All changes flow through `dev` before merging to `main`.

**Branch naming:**
| Type | Pattern | Example |
| --- | --- | --- |
| Feature / fix | `feature/<slug>` | `feature/fix-health-probe` |
| Documentation / README | `plan/<slug>` | `plan/readme-refresh` |
| Hotfix | `hotfix/<slug>` | `hotfix/cron-crash` |

**Process:**
1. Branch from `dev`.
2. Make your changes and test locally (`podman build` + health check).
3. Push and open a PR targeting `dev`.
4. CI must pass (Dev Makhija's pipeline gates the merge).
5. Adam approves and merges to `dev`; `main` is updated on release.

**README changes** are owned by Blair Fontaine and must follow this guide.
```

---

### 12. Links

**What it is:** A curated list of external references relevant to this project. This should be a clear list and is mainly used by the PLANNING Agent to monitor/reference upstraem repos, websites, chatrooms, etc. to help build the roadmap.

**Rules:**
- Include: upstream project, Docker Hub page, GitHub repo (if this is a mirror or fork), and any relevant docs.
- Do not include internal Slack links, local IP addresses, or credentials.
- Keep it short — 4–8 links max.
- Dead links are worse than no links. Check them when updating.

**Template:**
```markdown
## Links

- [Alpine Linux](https://alpinelinux.org) — upstream OS
- [Docker Hub](https://hub.docker.com/r/gautada/alpine) — published images
- [GitHub](https://github.com/gautada/alpine) — source
- [s6 Overlay](https://github.com/just-containers/s6-overlay) — init system reference
- [Eureka FARMS Project Board](https://github.com/users/gautada/projects/2) — active work
```

---

### 13. License

**What it is:** The license governing use and distribution of this project.  IF the project uses or extends another project like a container of alpine.  The license should be the upstream license.  If there is no upstream project then this should be the most open opensource liscense. IF upstream license cannot be determined then a bug needs to be assigned to Adam to fix.  Blair should maintain this but OWNER (Adam) can override. 

**Rules:**
- One line, linking to the `LICENSE` file in the repo.
- Include the license type in the text.
- If the project wraps upstream software, note the upstream license and link.

**Template:**
```markdown
## License

[MIT](./LICENSE) — upstream [Alpine Linux](https://alpinelinux.org/about/) is licensed separately.
```

---

## Omission Rules

Some sections may not apply to every repo. Use this table to decide:

| Section | May omit when... |
| --- | --- |
| Table of Contents | README is under 30 lines (rare) |
| Build | Image is not built from source in this repo |
| Install | This is a base image not deployed directly |
| Run | Same as Install; add a note instead |
| Contributing | Never omit — always include |

When omitting a section, **replace it with a one-line note** explaining why, rather than silently skipping it. This signals intent, not neglect.

---

## README Quality Checklist

Before committing a README update, verify:

- [ ] All 13 sections present or explicitly noted as omitted
- [ ] Description is one sentence, no period, matches GitHub repo description
- [ ] All badges link correctly and reflect live state
- [ ] Every code block is copy-pasteable and tested
- [ ] No placeholder text (`TODO`, `TBD`, `insert here`) remains
- [ ] Roadmap links to real open issues (not hypothetical ones)
- [ ] Build and Run sections match what CI actually does
- [ ] Contributing section references the `dev` branch and PR process
- [ ] Links section tested — no dead links

