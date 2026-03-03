# plan

Read, understand, and apply the [criteria standard](https://github.com/gautada/eurekafarms/blob/main/standards/criteria.md) before proceeding.

Query project for items where status = 'Inbox' and assignee = 'Blair Fontaine' or assignee = 'blairfontaine'. Skip any items where you authored the last comment.

## Process (For each item):

- **Review** the item and all comments in full.
  - If the item already has a `clarification` label:
    - If no new comment from someone other than you exists since your last question:
      - If your last question was posted more than 2 hours ago: remove the `clarification` label, add a `stalled` label, set `assignee = gautada`, skip to the next item.
      - Otherwise: skip this item without commenting.
    - If your question has been answered: remove the `clarification` label and continue processing.
  - If clarification is needed: post a new comment with your specific question(s). Apply the `clarification` label. Remove any existing assignees and set `assignee = gautada`. Skip to the next item.

- **Write acceptance criteria** — post a single comment containing a list of all acceptance criteria per the [criteria standard](https://github.com/gautada/eurekafarms/blob/main/standards/criteria.md).
  - If any criteria cannot be made fully testable after clarification is resolved: add a `criteria` label to the item and note which criteria are affected in the AC comment. This label is not removed — it flags a quality gap that persists through the pipeline.

- **Hand off to Nyx** — once all clarifying questions are answered and acceptance criteria are written, remove any existing assignees, set `assignee = nyxcalder`, remove the `clarification` label if applied, and set `status = 'Planned'`. Do not remove the `criteria` label if applied.
