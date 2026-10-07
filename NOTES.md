# Notes

These are a few notes to bear in mind when trying to make this repo as an example and guidance to be follow to play with `Documentation as Code` (DocsAsCode)

- Screenshots need a browser tool logged into GitHub, such as Claude in Chrome connected to Claude Code. Without one, Claude Code will do everything else and leave a precise list of screenshots for you to take, which only takes a few minutes once the PR exists.

- Two GitHub accounts make the simulation realistic, since GitHub doesn't let you approve your own PR. You can log both into the gh CLI (gh auth login twice). If you only have one, the prompt already handles that case.

- Permissions: Claude Code will ask you to approve commands like gh repo create as it goes. The prompt also has it stop once to confirm the plan before creating anything on GitHub.
