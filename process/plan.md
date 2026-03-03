# plan

Read, understand, and apply the [criteria standard](https://github.com/gautada/eurekafarms/blob/main/standards/criteria.md) before proceeding.

Query project for items where status = 'Inbox' and assignee = 'Blair Fontaine' or assignee = 'blairfontaine'. Skip any items where you authored the last comment.

## Process (For each item):

- **Review** the item and all comments in full.
  - If the item already has a `clarification` label:
    - If no new comment from someone other than you exists since your last question:
      - If your last question was posted more than 2 hours ago: remove all existing labels, add a `stalled` label, set `assignee = gautada`, skip to the next item.
      - Otherwise: skip this item without commenting.
    - If your question has been answered: remove the `clarification` label and continue processing.
  - If clarification is needed: post a new comment with your specific question(s). Apply the `clarification` label. Remove any existing assignees and set `assignee = gautada`. Skip to the next item.

- **Write acceptance criteria** — post a single comment containing a list of all acceptance criteria per the [criteria standard](https://github.com/gautada/eurekafarms/blob/main/standards/criteria.md).

- **Hand off to Nyx** — once all clarifying questions are answered and acceptance criteria are written, remove any/all existing assignees, set `assignee = nyxcalder`, remove the `clarification` label if applied, and set `status = 'Planned'`.
