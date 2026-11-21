# Places for a rule

Check the places in this order. Use the first place that fits.

## 1. Tool

The rule fits a tool if a program can check it without judgment.
Examples: formatting, import order, a forbidden function, a type error, a missing test run before a commit.

- Propose a lint rule, a formatter setting, a type check setting or a hook.
- Find the existing configuration, for example `.eslintrc`, `phpcs.xml`, `pyproject.toml` or `.claude/settings.json`.
- If no tool can check the rule, use the next place.

Reason: a tool checks each time. A text rule only helps if the agent reads it and follows it.

## 2. Project instructions

The rule fits the project if it is only true for this project, its stack or its team.
Examples: "Write SQL as nowdoc", "Use the PR template", "Check added lines against the writing rules before you commit".

- Use `CLAUDE.md` or `AGENTS.md` in the project root.
- If both exist, use the file that has rules of the same kind.
- If neither exists, ask the user which file to create.
- If the file has a section for the topic, add the rule there.

## 3. coding-principles

The rule fits `coding-principles` if it is true in each project, for each language.
Examples: "If a change refactors code and changes behavior, put each part into its own commit".

Find the source file. Do not change the installed copy. Reason: `install.sh` replaces the copy.

1. Read `.installed-by-skills-repo` in the installed skill folder, for example `~/.claude/skills/coding-principles/`.
   The file contains the path of the skills repository.
2. The source file is `<skills repository>/skills/coding-principles/SKILL.md`.
3. If the marker file or the source file does not exist, show the rule to the user. Do not write it.

Add the rule to the section that fits. Give it a short name in bold, like the other rules.

## Not sure

If two places fit, prefer the narrower place: tool before project, project before `coding-principles`.
Reason: a rule in the project cannot do harm in other projects.
