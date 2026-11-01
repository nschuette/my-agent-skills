#!/usr/bin/env bash
# Links each skill folder of this repository into two skill folders:
# - ~/.claude/skills: read by Claude Code and Cursor.
# - ~/.agents/skills: read by the Codex app and Cursor.
# The links are symlinks, so changes in the repository apply immediately.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

link_skills "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
link_skills "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
