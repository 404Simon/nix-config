#!/usr/bin/env bash
# Render a pretty preview of an rmpc snapshot JSON file for fzf.
# Usage: rmpc_snapshot_preview.sh <file.json>

set -euo pipefail

file="${1:-}"
if [[ -z "$file" || ! -f "$file" ]]; then
  echo "(no snapshot selected)"
  exit 0
fi

label=$(jq -r '.label // "Unknown"' "$file")
when=$(jq -r '.created_at_human // "?"' "$file")
n=$(jq -r '.queue | length' "$file")
cur=$(jq -r '.current_song.file // ""' "$file")
elapsed=$(jq -r '.status.elapsed.secs // 0' "$file")
duration=$(jq -r '.status.duration.secs // 0' "$file")

printf '=== %s ===\n' "$label"
printf 'saved: %s\n' "$when"
printf 'queue: %s songs\n\n' "$n"

# Render each track, marking the saved-current one with ▶.
jq -r --arg c "$cur" '
  .queue[] |
  (
    if .file == $c then "▶ " else "  " end
  ) + (
    (.metadata.artist // "?")
    + " - "
    + (.metadata.title // .file)
  )
' "$file"

printf '\nelapsed: %ss / %ss\n' "$elapsed" "$duration"