# Task: Set up a GitHub "docs-review-sandbox" review sandbox and write a reviewer guide

## Context
We want to replace Word-based document reviews with a docs-as-code process:
documents are written in Markdown, stored in a GitHub repo, reviewed through
Pull Requests (line comments + "Suggest changes" blocks), and published as
PDF/DOCX generated automatically with Pandoc. Before rolling this out, I want
a sandbox repository where the full review cycle is simulated end to end,
plus a guide (with screenshots) that teaches reviewers and authors the process.

## Environment
- Working folder: [ABSOLUTE PATH TO FOLDER]
- GitHub owner (user or org): [GITHUB_OWNER]
- Repo name: docs-review-sandbox
- Visibility: [public / private] (note: branch protection on private repos
  requires a paid GitHub plan; if private and protection fails, tell me)
- Author account (gh CLI): [AUTHOR_GITHUB_USERNAME]
- Reviewer account (gh CLI): [REVIEWER_GITHUB_USERNAME, or "none"]
- Guide language: [English / Spanish / ...]

## Ground rules
1. First, check prerequisites and report back before changing anything:
   git, gh CLI (installed and authenticated; `gh auth status`), and whether
   a browser automation tool is available for screenshots (e.g. Claude in
   Chrome or Playwright). Pandoc/Docker locally are optional; the build
   runs in GitHub Actions.
2. Show me your plan and ask for confirmation before creating the GitHub
   repository. After that, proceed without asking unless something fails
   or a decision is genuinely mine.
3. Never touch any repository other than the sandbox.
4. If you can't do something (e.g. approve a PR without a second account,
   or take screenshots), don't fake it: do everything else, leave a clearly
   marked placeholder, and list it in the final summary.

## Part 1 – Repository setup
Create the repo locally in the working folder and push it to GitHub.
Commit directly to `main` only these files:

- `README.md`: short explanation of the sandbox's purpose and the review
  process (one paragraph + link to REVIEWING.md once it exists).
- `.github/workflows/build-docs.yml`: GitHub Actions workflow triggered on
  pull_request and on push to main (paths: docs/**.md). It checks out the
  repo, renders every docs/*.md to PDF and DOCX using the `pandoc/latex`
  Docker image via `docker run` (not as a job container: JS actions fail in
  Alpine containers), and uploads the output/ folder with
  actions/upload-artifact@v4 as an artifact named `rendered-documents`.
  Pin a specific pandoc/latex version tag.
- `.github/pull_request_template.md` with sections: Document(s) under review;
  Type of review (checkboxes: full review of new document / partial review of
  changes); Summary of changes; Reviewer instructions (read rendered view via
  "Display the rich diff" or download PDF/DOCX from Checks → Artifacts;
  comment on specific lines; use "Suggest changes" for wording; finish with
  "Review changes" → Comment / Request changes / Approve); Review deadline.

Then configure branch protection on `main` (gh api or rulesets): require a
pull request, require 1 approval, require conversation resolution.

## Part 2 – Sample document (via PR, never directly on main)
Create branch `docs/sample-policy` and add `docs/sample-policy.md`. Because
the file doesn't exist on main, every line will be commentable, which
simulates a full review. Write ONE SENTENCE PER LINE (this is a convention
we want to teach). Use this content, including the deliberate errors:

```markdown
---
title: "Information Security Policy (SAMPLE)"
author: "Documentation Team"
date: "2026-10-07"
---

# Purpose

This policy defines the rules for protecting company information.
It applies to all employees, contractors and third parties.
The policy is reviewed anually by the Security Office.

# Scope

All information systems owned or operated by the company are in scope.
Personal devices are in scope when they access company data.

# Password requirements

Passwords must have at least 12 characters.
Passwords must be changed regularly.
Passwords must not be reused across the last 5 changes.
Accounts are locked after 3 failed login attempts.

# Data classification

| Level        | Example               | Encryption required |
|--------------|-----------------------|---------------------|
| Public       | Website content       | No                  |
| Internal     | Org charts            | No                  |
| Confidential | Customer data         | Yes                 |
| Restricted   | Encryption keys       |                     |

# Incident reporting

Security incidents must be reported within 24 hours.
Reports are sent to the Security Office using the incident form.
Critical incidents must be reported within 48 hours.
```

Planted issues: typo "anually"; vague "changed regularly"; missing value in
the Restricted row; critical incidents (48h) have a longer deadline than
normal ones (24h).

Open a PR from `docs/sample-policy` into `main` as the author account, with
the template filled in. Confirm the Actions build succeeds and the artifact
contains the PDF and DOCX; fix the workflow if it doesn't.

## Part 3 – Simulate the review cycle
Using `gh` / `gh api` (switch accounts with `gh auth switch` when needed),
simulate this sequence on the PR:

1. Reviewer starts a review (pending) containing:
   a. a single-line suggestion block fixing "anually" → "annually";
   b. a multi-line comment over the three password lines saying
      "changed regularly" is vague and asking for a concrete period;
   c. a plain comment on the Restricted row: "Missing value; should be Yes";
   d. a comment on the 48h line questioning the inconsistency with 24h.
2. Reviewer submits the review as "Request changes".
3. Author replies to the 48h thread, applies the typo suggestion as a commit,
   fixes the other issues in a new commit, and resolves all threads.
4. Reviewer approves.
5. Author merges (squash), and you verify the build on main produces the
   final artifact.

If there's no reviewer account, do steps 1–3 as the author (submit as
"Comment" instead of "Request changes"), skip the approval, temporarily
note that merging is blocked by protection (that's itself a useful
screenshot), and tell me what's missing.

## Part 4 – Screenshots
If a browser tool is available and logged into GitHub, capture screenshots
into `guide/images/` with descriptive names (e.g. 04-suggest-changes.png)
for these moments: PR creation form; "Files changed" with rich diff
(rendered view); Checks → artifact download; the suggestion editor; a
multi-line selection comment; the "Review changes" dialog showing
Comment / Request changes / Approve; the Conversation tab with threads;
"Commit suggestion" / "Add suggestion to batch"; a resolved thread; the
merge box blocked and unblocked; the final artifact on main.
Crop or annotate them (arrows/boxes) if your tools allow. If you can't take
screenshots, create the guide with placeholders like
`![TODO: screenshot – Review changes dialog](images/08-review-changes.png)`
and give me the exact list of screenshots to take myself.

## Part 5 – The reviewer guide
Write `REVIEWING.md` in the repo (and also export it to PDF and DOCX using
the same Pandoc pipeline, so non-technical people can read it). It should:
- open with a short "why we review this way" section (single source of
  truth, comments tied to exact sentences, suggestions work like tracked
  changes, full history of who proposed/reviewed/approved what, published
  PDF/DOCX always matches the approved text, no Git knowledge needed to
  review, everything happens in the browser);
- have a "For reviewers" section: open the PR, read the rendered version or
  download PDF/DOCX, comment on a line, comment on several lines, suggest
  changes, batch comments with "Start a review", submit with the right
  verdict, re-review only what changed;
- have a "For authors" section: branch, one sentence per line, open PR with
  the template, full vs partial review (the "add the whole file" trick),
  answer comments, commit suggestions (single and batch), push fixes,
  resolve threads, merge, where to get the published files;
- use the real PR from this simulation as the worked example, with
  screenshots at each step;
- end with a short FAQ (e.g. "I can't see the + button", "Can I review in
  Word?", "Where is the final PDF?") and a one-page cheat sheet.
Deliver the guide itself through a PR into main too, so it's reviewed with
the same process.

## Final report
When done, give me: the repo URL, the PR URLs, what worked, anything you
couldn't do and why, the list of screenshots still needed (if any), and
suggested next steps to adapt this to our real repository.
