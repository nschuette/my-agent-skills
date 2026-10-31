#!/usr/bin/env bash
# Links each skill folder of this repository into ~/.claude/skills.
# The links are symlinks, so changes in the repository apply immediately.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$TARGET"

for dir in "$REPO"/skills/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  link="$TARGET/$name"
  if [ -L "$link" ]; then
    ln -sfn "${dir%/}" "$link"
    echo "updated: $name"
  elif [ -e "$link" ]; then
    echo "skipped (exists and is not a symlink): $link" >&2
  else
    ln -s "${dir%/}" "$link"
    echo "linked: $name"
  fi
done
