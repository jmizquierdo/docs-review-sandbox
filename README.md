# docs-review-sandbox

This repository is a sandbox for trying out a docs-as-code review process before we use it for real documents.
Documents are written in Markdown under `docs/` and changed only through Pull Requests.
Reviewers comment on exact lines and propose wording with "Suggest changes", working like tracked changes in Word.
Each Pull Request is approved before it is merged into `main`.
GitHub Actions turns every document into PDF and DOCX, so the published files always match the approved text.
The step-by-step guide for reviewers and authors is in [REVIEWING.md](REVIEWING.md).

## How documents are rendered

[tools/md-to-docx.py](tools/md-to-docx.py) converts each document to DOCX with Pandoc, then applies the formatting rules in [docx-format.yaml](docx-format.yaml): page breaks, centred images and tables, caption size, and code block shading.
LibreOffice then converts that DOCX to PDF, so both files look the same.
To change the look of every document, change `docx-format.yaml` through a Pull Request.

To render a document on your computer (Python 3 and `pip install -r requirements.txt`):

```bash
python tools/md-to-docx.py docs/sample-policy.md output/sample-policy.docx --config docx-format.yaml
```

To render every document exactly as GitHub Actions does, DOCX and PDF, with Docker:

```bash
docker build -t docs-builder -f tools/Dockerfile .
docker run --rm -v "$PWD:/work" docs-builder bash tools/render-all.sh
```

## How this started

This repository was built by an AI coding agent, following the brief in [PROMPT.md](PROMPT.md) and the setup notes in [NOTES.md](NOTES.md).
Both files are kept as they were written to show where the project came from.
