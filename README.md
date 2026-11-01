# my-agent-skills

Personal skills for AI coding agents. It supports Claude Code, Cursor and the Codex app.

This is my personal setup. You can use it, but I do not give support.

## Skills

| Skill | What it does | Start |
| --- | --- | --- |
| `create-plan` | Writes a phased implementation plan with success criteria. Writes no code. | `/create-plan <task>` (Claude Code, Cursor) or `$create-plan <task>` (Codex), only on request |

## Install

Requirements: git and at least one of Claude Code, Cursor or the Codex app, on macOS or Linux.

```bash
# Get the repository
git clone https://github.com/nschuette/my-agent-skills.git

# Go to the repository folder
cd my-agent-skills

# Link the skills into ~/.claude/skills/ and ~/.agents/skills/
./install.sh
```

`install.sh` links each folder in `skills/` into `~/.claude/skills/` and `~/.agents/skills/`.
Changes in the repository apply immediately.
To use different target folders, set `CLAUDE_SKILLS_DIR` and `AGENTS_SKILLS_DIR`.

Each agent reads these folders:

- Claude Code: `~/.claude/skills/`.
- Cursor: `~/.claude/skills/` and `~/.agents/skills/`.
- Codex app: `~/.agents/skills/`.

Then add the [recommended settings](#recommended-settings).

## Usage

Example: a plan for a Jira ticket.

1. Create a branch for the task: `git switch -c feature/PROJ-123-csv-export`.
2. Run `/create-plan PROJ-123`. In Codex, run `$create-plan PROJ-123`.
   If a ticket tool such as a Jira MCP server is connected, the agent reads the ticket.
   If not, the agent asks you to paste the ticket text.
3. Answer the questions of the agent and choose an approach.
4. Approve the outline. The agent writes the plan to the plan folder. See [Work files](#work-files).
5. Review the plan. Give feedback in the same session. The agent changes the plan file.
6. Start a new session and say: `Implement <path of the plan>`.
   The agent implements one phase at a time. After each phase, it stops for your approval.

The task can also be a text or a file:

```
/create-plan add a CSV export to the report page
/create-plan notes/csv-export.md
```

You can also describe the task in the conversation first. Then run `/create-plan` without a task.

## Work files

Skills write plans and research documents outside of the project repository:

```
<work root>/<project>/<branch>/YYYY-MM-DD-<slug>.<type>.md
```

The files stay out of git. All worktrees of a project use the same files.

The work root is `$AGENTS_WORK_DIR`. If the variable is not set, the work root is `~/agents/work`.
The value must be an absolute path, because the agents do not expand `~` in settings files.

To use a different work root, set the variable in each agent:

- Claude Code: add `"env": { "AGENTS_WORK_DIR": "/Users/<you>/my/work" }` to `~/.claude/settings.json`.
- Codex: add `set = { AGENTS_WORK_DIR = "/Users/<you>/my/work" }` to the section `[shell_environment_policy]` of `~/.codex/config.toml`.
- Cursor: add `export AGENTS_WORK_DIR="/Users/<you>/my/work"` to `~/.zshrc`. Not checked yet.

## Recommended settings

If you set `AGENTS_WORK_DIR`, replace each `agents/work` path in these settings with your work root.

### Claude Code

Add this to `~/.claude/settings.json`. Replace `<you>` with your user name.

```json
{
  "permissions": {
    "additionalDirectories": ["/Users/<you>/agents/work"],
    "allow": ["Edit(~/agents/work/**)"],
    "ask": ["Bash(git commit *)"]
  }
}
```

- `additionalDirectories`: the agent can read work files in each session.
- `allow`: the agent can write work files without a prompt. The `allowed-tools` of a skill are not sufficient, because they apply only in the first turn.
  For an absolute path, start the rule with `//`, for example `Edit(//Users/<you>/my/work/**)`. Reason: Claude Code reads one `/` as relative to the settings file.
- `ask`: optional. The agent asks before each commit.

### Codex

Add this to `~/.codex/config.toml`. Replace `<you>` with your user name.

```toml
[sandbox_workspace_write]
writable_roots = ["/Users/<you>/agents/work"]
```

The sandbox blocks writes outside of the workspace.
The entry applies in the sandbox mode `workspace-write`.
Without the entry, Codex asks for approval for each write.

### Cursor

Not checked yet. Cursor can ask before each write to `~/agents/work`.
No setting that prevents this is confirmed.

## Known limitations

- Only Claude Code replaces `$ARGUMENTS`. The other agents take the task from the message.
- Cloud agents are not supported. The skills and the work root are only on the local computer.
- In Claude Code, the skill can write without a prompt only to `~/agents/work`. Reason: `allowed-tools` cannot read environment variables. For a different work root, add an `allow` rule in the settings.
- Templates are in `SKILL.md`, not in `assets/`. Reason: Claude Code asks for permission before it reads files in a symlinked skill folder. See [anthropics/claude-code#106433](https://github.com/anthropics/claude-code/issues/106433).

## Conventions

Writing rules, skill conventions and the commit format are in [CLAUDE.md](CLAUDE.md).

## Credits

`create-plan` uses ideas from the research, plan and implement workflow of [HumanLayer](https://github.com/humanlayer/humanlayer).

## License

[MIT](LICENSE)
