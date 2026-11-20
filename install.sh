#!/usr/bin/env bash
# Copies each skill folder of this repository into two skill folders:
# - ~/.claude/skills: read by Claude Code and Cursor.
# - ~/.agents/skills: read by the Codex app and Cursor.
# The script copies the folders and does not link them.
# Reason: Claude Code checks a Read rule against the real path, so it blocks reads in a symlinked skill folder.
# After a change in the repository, run the script again.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# This file marks a skill folder that the script copied. The script replaces only marked folders.
MARKER=".installed-by-skills-repo"

copy_skills() {
  local target="$1" dir name dest
  mkdir -p "$target"
  for dir in "$REPO"/skills/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    dest="$target/$name"
    if [ -L "$dest" ]; then
      # A symlink from an older version of this script.
      rm "$dest"
    elif [ -e "$dest" ] && [ ! -e "$dest/$MARKER" ]; then
      echo "skipped (exists and was not installed by this script): $dest" >&2
      continue
    else
      rm -rf "$dest"
    fi
    cp -R "${dir%/}" "$dest"
    echo "$REPO" > "$dest/$MARKER"
    echo "copied: $name to $target"
  done
}

copy_skills "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
copy_skills "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
