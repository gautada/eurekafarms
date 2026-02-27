# Plan README Playbook

These are the steps I follow whenever Adam tags a repository with the `plan-readme` topic. The goal: audit the repo’s current README coverage, understand open work, and stage a planning branch (`plan/<focus>`) with whatever documentation or task breakdown is needed next.

---

## 1. Discover target repositories
1. List every `gautada/*` repo that carries the topic:
   ```bash
   gh repo list gautada --topic plan-readme --json name,sshUrl,description --limit 200
   ```
2. If nothing is returned, stop — there is no work.
3. Otherwise, work through the repos one at a time (oldest untouched first if timestamps are available).

## 2. Clone + hydrate the repo locally
1. `git clone <repo>` (or `git fetch --all` if already present).
2. `git remote -v` to confirm I have push rights.
3. `git branch -r` to see every remote branch.
4. `git fetch --prune` so local state mirrors GitHub.

## 3. Full-state review checklist
For each repo (and each branch noted above):

| Area | Actions |
| --- | --- |
| README + docs | Open every README, docs folder, and `/cohort/plan` assets. Capture gaps, outdated steps, or missing acceptance criteria. |
| Branches | Scan active branches (`git branch -r`, `gh pr list`). Note any stale plan branches that should be closed or refreshed. |
| Issues | `gh issue list --state all` to understand current backlog. Flag anything blocking README updates. |
| Automations | Check workflows/scripts referenced by the README so instructions stay truthful. |

Document findings as bullet notes in `notes.md` (or similar) inside the new plan branch.

## 4. Create the planning branch
1. Choose a concise slug, e.g. `plan/readme-refresh`, `plan/labs-docs`, etc.
2. `git checkout -b plan/<slug>` from the latest default branch (usually `main`).
3. Commit any planning artifacts (notes, updated README drafts, issue templates, etc.). Keep commits scoped to planning/documentation.
4. Push with:
   ```bash
   git push -u origin plan/<slug>
   ```

## 5. Surface follow-ups
1. Open/Update issues summarizing the README gaps and proposed fixes.
2. Link the plan branch + issues back to Adam (Slack or GitHub comment) so Nyx knows work is ready.
3. Remove the `plan-readme` topic once the plan is delivered (or ask Adam to do it).

---

**Success =** every `plan-readme` repo has an up-to-date planning branch, documented findings, and clear tasks queued for implementation.
