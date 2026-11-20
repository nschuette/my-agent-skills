# Skills

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
git clone https://github.com/nschuette/skills.git

# Go to the repository folder
cd skills

# Copy the skills into ~/.claude/skills/ and ~/.agents/skills/
./install.sh
```

`install.sh` copies each folder in `skills/` into `~/.claude/skills/` and `~/.agents/skills/`.
After a change in the repository, run `./install.sh` again.
The script replaces only folders that it installed, and symlinks from older versions of the script.
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
4. Approve the outline. The agent writes the plan to `.agent-work/plans/<branch>/`. See [Work files](#work-files).
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

Skills write plans and research documents into the project:

```
<project root>/.agent-work/plans/<branch>/YYYY-MM-DD-<slug>.<type>.md
```

You can open the files in your editor next to the code.
The skills never commit these files. The skill creates `.agent-work/.gitignore` with the line `*`, so git ignores the folder.
Nothing changes in the repository. You need no global gitignore.

Do not run `git clean -fdx`, because it deletes ignored files and so your plans. Use `git clean -fdx -e .agent-work` instead.

## Recommended settings

### Claude Code

Add this to `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["Read(~/.claude/skills/**)"],
    "ask": ["Bash(git commit *)"]
  }
}
```

- `allow`: the agent can read the files of a skill without a prompt. The `allowed-tools` of a skill are not sufficient, because they apply only in the first turn.
- `ask`: optional. The agent asks before each commit.

## Known limitations

- Only Claude Code replaces `$ARGUMENTS`. The other agents take the task from the message.
- Cloud agents are not supported. The skills are only on the local computer.
- `install.sh` copies the skills and does not link them. Reason: Claude Code checks a `Read` rule against the real path of a file. A rule for `~/.claude/skills/` does not match a file in a symlinked folder. See [anthropics/claude-code#106433](https://github.com/anthropics/claude-code/issues/106433).

## Conventions

Writing rules, skill conventions and the commit format are in [CLAUDE.md](CLAUDE.md).

## Credits

`create-plan` uses ideas from the research, plan and implement workflow of [HumanLayer](https://github.com/humanlayer/humanlayer).

## License

[MIT](LICENSE)
