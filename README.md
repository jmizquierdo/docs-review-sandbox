# docs-review-sandbox

This repository is a sandbox for trying out a docs-as-code review process before we use it for real documents.
Documents are written in Markdown under `docs/` and changed only through Pull Requests.
Reviewers comment on exact lines and propose wording with "Suggest changes", working like tracked changes in Word.
Each Pull Request is approved before it is merged into `main`.
GitHub Actions turns every document into PDF and DOCX with Pandoc, so the published files always match the approved text.

## How this started

This repository was built by an AI coding agent, following the brief in [PROMPT.md](PROMPT.md) and the setup notes in [NOTES.md](NOTES.md).
Both files are kept as they were written to show where the project came from.
