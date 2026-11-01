#!/usr/bin/env bash
# Links each skill folder of this repository into two skill folders:
# - ~/.claude/skills: read by Claude Code and Cursor.
# - ~/.agents/skills: read by the Codex app and Cursor.
# The links are symlinks, so changes in the repository apply immediately.
# If AGENTS_WORK_DIR is set, the script also prints the agent settings for this work root.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${AGENTS_WORK_DIR:-}"

if [ -n "$WORK_DIR" ] && [ "${WORK_DIR#/}" = "$WORK_DIR" ]; then
  echo "error: AGENTS_WORK_DIR must be an absolute path: $WORK_DIR" >&2
  exit 1
fi

link_skills() {
  local target="$1" dir name link
  mkdir -p "$target"
  for dir in "$REPO"/skills/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    link="$target/$name"
    if [ -L "$link" ]; then
      ln -sfn "${dir%/}" "$link"
      echo "updated: $name in $target"
    elif [ -e "$link" ]; then
      echo "skipped (exists and is not a symlink): $link" >&2
    else
      ln -s "${dir%/}" "$link"
      echo "linked: $name in $target"
    fi
  done
}

# The Claude Code rule starts with "//", because Claude Code reads one "/" as relative to the settings file.
print_work_dir_settings() {
  local root="$1"
  cat <<EOF

Add these settings for the work root $root.

Claude Code: ~/.claude/settings.json
{
  "env": { "AGENTS_WORK_DIR": "$root" },
  "permissions": {
    "additionalDirectories": ["$root"],
    "allow": ["Edit(/$root/**)"]
  }
}

Codex: ~/.codex/config.toml
[shell_environment_policy]
set = { AGENTS_WORK_DIR = "$root" }

[sandbox_workspace_write]
writable_roots = ["$root"]

Cursor: ~/.zshrc
export AGENTS_WORK_DIR="$root"
EOF
}

link_skills "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
link_skills "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"

if [ -n "$WORK_DIR" ]; then
  print_work_dir_settings "$WORK_DIR"
fi
