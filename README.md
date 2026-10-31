# my-agent-skills

Personal skills for AI coding agents. Version 1 supports Claude Code only.

This is my personal setup. You can use it, but I do not give support.

## Skills

| Skill | What it does | Start |
| --- | --- | --- |
| `create-plan` | Writes a phased implementation plan with success criteria. Writes no code. | `/create-plan <task>` only |

## Install

Requirements: Claude Code and git on macOS or Linux.

```bash
# Get the repository
git clone https://github.com/nschuette/my-agent-skills.git

# Go to the repository folder
cd my-agent-skills

# Link the skills into ~/.claude/skills/
./install.sh
```

`install.sh` links each folder in `skills/` into `~/.claude/skills/`.
Changes in the repository apply immediately.
To use a different target folder, set `CLAUDE_SKILLS_DIR`.

Then add the [recommended settings](#recommended-settings).

## Usage

Example: a plan for a Jira ticket.

1. Create a branch for the task: `git switch -c feature/PROJ-123-csv-export`.
2. Run `/create-plan PROJ-123`.
   If a ticket tool such as a Jira MCP server is connected, the agent reads the ticket.
   If not, the agent asks you to paste the ticket text.
3. Answer the questions of the agent and choose an approach.
4. Approve the outline. The agent writes the plan to `~/agents/work/<project>/<branch>/`.
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
~/agents/work/<project>/<branch>/YYYY-MM-DD-<slug>.<type>.md
```

The files stay out of git. All worktrees of a project use the same files.

## Recommended settings

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
- `ask`: optional. The agent asks before each commit.

## Known limitations

- Claude Code only. `disable-model-invocation` and `argument-hint` are Claude Code fields.
- Templates are in `SKILL.md`, not in `assets/`. Reason: Claude Code asks for permission before it reads files in a symlinked skill folder. See [anthropics/claude-code#106433](https://github.com/anthropics/claude-code/issues/106433).

## Conventions

Writing rules, skill conventions and the commit format are in [CLAUDE.md](CLAUDE.md).

## Credits

`create-plan` uses ideas from the research, plan and implement workflow of [HumanLayer](https://github.com/humanlayer/humanlayer).

## License

[MIT](LICENSE)
