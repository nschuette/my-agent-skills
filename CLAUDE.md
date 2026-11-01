# my-agent-skills

Personal skills for AI coding agents. It supports Claude Code, Cursor and the Codex app.

## Layout

- `skills/<name>/`: one folder for each skill. The folder name is the skill name. The structure follows the [Agent Skills specification](https://agentskills.io/specification):
  - `SKILL.md`: required. Frontmatter and instructions.
  - `assets/`: templates and other static files.
  - `references/`: documentation that the agent reads only when necessary.
  - `scripts/`: code that the agent runs.
  - `agents/openai.yaml`: Codex settings, for example the invocation policy.

  Claude Code asks for permission before it reads files in these folders, because they are outside of the project folder. Use them only when necessary.
- `install.sh`: links each skill folder into `~/.claude/skills/` and `~/.agents/skills/`.
- `README.md`: install steps and the list of skills. Update the list when you add or remove a skill.

## Writing rules

Write all files in this repository in English.
Follow the writing rules of ASD-STE100 (Simplified Technical English).
Do not apply the strict STE dictionary. Technical names, commands and paths are always allowed.

1. Write instructions in the imperative: "Read the file." Not: "You should read the file."
2. Write one instruction in each sentence.
3. Keep instructions to 20 words or fewer. Keep descriptive sentences to 25 words or fewer.
4. Use the active voice.
5. Use one word for one thing. Do not use synonyms. Example: always "plan", never "spec" or "proposal".
6. Write the condition first, then the instruction: "If the branch is the default branch, stop."
7. Use numbered lists for steps in a sequence. Use bullet lists for items without a sequence.
8. Do not use capital letters or other emphasis to make a rule stronger. Give the reason instead.
9. Write only what the agent cannot find in the code or in its default behavior.
10. Keep each `SKILL.md` short. Put a template in a section "Template" at the end of `SKILL.md`. Put it in a code block with four backticks. Reason: then the headings of the template are clearly separate from the headings of the skill.

## Skill conventions

- Frontmatter: `name` is the folder name. `description` tells the agent what the skill does and when to use it.
- `disable-model-invocation` works in Claude Code and Cursor. `argument-hint` works only in Claude Code. Neither field is part of the Agent Skills specification.
- In `SKILL.md`, refer to other files with a path relative to the skill folder, for example `references/api.md`.
- If a skill starts a workflow or writes files, set `disable-model-invocation: true` and add `agents/openai.yaml` with `allow_implicit_invocation: false`. Then the skill runs only when the user starts it.
- Write `$ARGUMENTS` only once, and only in a line that also makes sense without substitution. Reason: only Claude Code replaces it.
- A skill must work without this repository. It cannot rely on this `CLAUDE.md`, because `install.sh` links only the skill folder.
- Do not put project-specific details in a skill: test commands, commit format, ticket keys. These come from the project's `CLAUDE.md` or `AGENTS.md`.
- Do not put company-internal details in this repository. The repository can become public.

## Agent work files

Skills write work files (plans, research documents) outside of the project repository:

```
<work root>/<project>/<branch>/YYYY-MM-DD-<slug>.<type>.md
```

- `<work root>`: `$AGENTS_WORK_DIR`. If the variable is not set, `~/agents/work`.
- `<project>`: folder name of the main repository. This is also true in a worktree.
- `<branch>`: current branch. Replace each `/` with `-`.
- `<type>`: `plan` or `research`.

## Commits

Use Conventional Commits in English.

- Format: `<type>(<scope>): <summary>`
- Types: `feat`, `fix`, `docs`, `refactor`, `chore`.
- Scope: the skill name (`create-plan`) or the changed part (`install`, `readme`). For changes across the repository, omit the scope.
- Summary: 50 characters or fewer, lowercase, imperative, no period at the end.
- Body: optional. Use bullet points that tell what changed and why.
- Do not add attribution lines such as `Co-Authored-By`.

## Test a skill

1. Run `./install.sh`.
2. Start a new session of each supported agent in a test project.
3. Run the skill and check the result.
