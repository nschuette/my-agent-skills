# my-agent-skills

Personal skills for AI coding agents. Version 1 supports Claude Code only.

This is a personal setup. I do not give support.

## Install

```bash
git clone <repo-url> ~/Development/my-agent-skills
cd ~/Development/my-agent-skills
./install.sh
```

`install.sh` links each folder in `skills/` into `~/.claude/skills/`.
Changes in the repository apply immediately.
To use a different target folder, set `CLAUDE_SKILLS_DIR`.

## Skills

| Skill | What it does | Start |
| --- | --- | --- |
| `create-plan` | Writes a phased implementation plan with success criteria. Writes no code. | `/create-plan <task>` only |

## Work files

Skills write plans and research documents outside of the project repository:

```
~/agents/work/<project>/<branch>/YYYY-MM-DD-<slug>.<type>.md
```

The files stay out of git. All worktrees of a project use the same files.

## Recommended settings

Add this to `~/.claude/settings.json`. Use the absolute path of your home folder.

```json
{
  "permissions": {
    "additionalDirectories": ["/Users/<you>/agents/work"],
    "allow": ["Edit(~/agents/work/**)"],
    "ask": ["Bash(git commit *)"]
  }
}
```

- `additionalDirectories` lets the agent read and find work files in other sessions.
- The `allow` rule lets the agent write work files without a prompt. The `allowed-tools` of a skill are not sufficient, because they apply only in the first turn of the skill.- The `ask` rule makes the agent ask before each commit.

## Conventions

Writing rules, skill conventions and the commit format are in [CLAUDE.md](CLAUDE.md).

## Credits

`create-plan` uses ideas from the research, plan and implement workflow of [HumanLayer](https://github.com/humanlayer/humanlayer).
