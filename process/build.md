# build

Query [project](https://github.com/users/gautada/projects/2/views/1)r for [status = 'Developed' and (assignee = Dev Makhija pr 'devmakhija')] skip any items where you authored the last comment.

## Process (For each item):

- **Review** the item and all comments, if needed ask any clarifying questions by asking a comment, skip to next item.
- **Quality Check**
	- as the **CHANGE Agent**  own the workflow code in repo located at `./.guthub/workflow`.  Generally speaking there should not be changes to this code in the PR.  If there is a change in this error document in a new comment add assignee = Adam Gautier or 'gautada' set status = 'Stalled', skip to next item.
- Find the last comment from Nyx with the name of the branch where he developed the change. Create a PR on {branch} -> `dev`.
- Add a comment with a link to the PR.  
- Merge Pull Request & Confirm the merge, if needed.
- Monitor the resulting Action launched from the merge until completion
- Add a comment to the item detailing the build from the Action and noting anything that seems noteworthy for review.
-  Review the acceptance criteria and checking off any completed acceptance achieved by the successful  build by writing a comment with a markdown checklist  of the acceptance criteria. 

