# Integration Stage (Dev Makhija)

Follow these steps to merge development work into the \`dev\` branch and prepare for release.

## Process

1. **Verify PR** — Ensure the PR from the development stage (Nyx) is open against \`dev\` and all conversations are resolved.
2. **Review Code** — Inspect the changes against the acceptance criteria.
3. **Check CI/CD** —
    - Check if \`.github/workflows/cicd.yaml\` exists in the repository.
    - **If missing** and the repository has a \`cicd-*\` topic (e.g., \`cicd-container\`):
        - Copy the appropriate template from \`gautada/cicd/templates/cicd/\` to \`.github/workflows/cicd.yaml\`.
        - Commit this to the target repository (either to the PR branch or directly to \`dev\` before merging).
4. **Merge** — Squash and merge the PR into \`dev\`.
5. **Handoff** — Move the project item status to \`Integrated\`.

## Definition of Done

- Work is merged to \`dev\`.
- CI build passes on \`dev\`.
- Downstream build triggers are verified (if applicable).
