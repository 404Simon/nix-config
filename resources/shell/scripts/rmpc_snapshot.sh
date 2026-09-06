#!/usr/bin/env bash
# Create or restore rmpc queue snapshots.
# Snapshots are stored as JSON files in ~/.local/share/rmpcsnapshots/.
# Each snapshot captures: current song, elapsed time, full queue (in order),
# repeat/random/single/consume modes.
#
# When called with no argument, opens an fzf picker to choose an action
# (Create / Restore) and then the snapshot to restore.

set -euo pipefail

SNAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/rmpcsnapshots"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$SNAP_DIR"

# ---------- helpers ----------

ts() { date +"%Y%m%d-%H%M%S"; }

sanitize() {
  # Make a string safe for use as a filename: keep alnum, dash, underscore,
  # replace spaces with underscores, truncate.
  printf '%s' "$1" \
    | tr ' ' '_' \
    | tr -cd 'A-Za-z0-9_-' \
    | cut -c1-80
}

current_song_label() {
  # Pretty "Artist - Title" of the current song, or a fallback.
  local raw label
  raw="$(rmpc song 2>/dev/null || true)"
  if [[ -z "$raw" || "$raw" == "null" ]]; then
    echo "No song playing"
    return
  fi
  label="$(printf '%s' "$raw" | jq -r '
    (.metadata.artist // empty) + " - " + (.metadata.title // .file // "Unknown")
  ' 2>/dev/null || true)"
  printf '%s' "${label:-Unknown}"
}

current_song_filename() {
  # Short filename for the current song, used as default snapshot name.
  local label
  label="$(current_song_label)"
  sanitize "$label"
}

# ---------- capture ----------

capture_snapshot() {
  local name_input="$1"
  local status_json song_json queue_json
  local song_label default_name final_name ts_str filename

  status_json="$(rmpc status 2>/dev/null || echo '{}')"
  song_json="$(rmpc song 2>/dev/null || echo 'null')"
  queue_json="$(rmpc queue 2>/dev/null || echo '[]')"

  song_label="$(current_song_label)"
  default_name="$(current_song_filename)"
  ts_str="$(ts)"

  if [[ -z "$name_input" ]]; then
    final_name="${default_name}_${ts_str}"
  else
    final_name="$(sanitize "$name_input")_${ts_str}"
  fi

  filename="${SNAP_DIR}/${final_name}.json"

  jq -n \
    --argjson status "$status_json" \
    --argjson song "$song_json" \
    --argjson queue "$queue_json" \
    --arg name "$final_name" \
    --arg label "$song_label" \
    --arg created_at "$(date -Iseconds)" \
    --arg created_at_human "$(date '+%Y-%m-%d %H:%M:%S')" \
    '{
      name: $name,
      label: $label,
      created_at: $created_at,
      created_at_human: $created_at_human,
      status: $status,
      current_song: $song,
      queue: $queue
    }' > "$filename"

  echo "Saved snapshot: $filename"
  notify-send -t 3000 "rmpc snapshot saved" "$song_label"
}

# ---------- restore ----------

restore_snapshot() {
  local file="$1"
  local idx elapsed_secs song_file play_pos

  if [[ ! -f "$file" ]]; then
    echo "Snapshot file not found: $file" >&2
    return 1
  fi

  if [[ "$(jq -r '.queue | length' "$file")" -eq 0 ]]; then
    echo "Snapshot has an empty queue, nothing to restore." >&2
    notify-send -t 3000 "rmpc snapshot" "Empty queue, nothing to restore."
    return 1
  fi

  song_file="$(jq -r '.current_song.file // empty' "$file")"
  elapsed_secs="$(jq -r '.status.elapsed.secs // 0' "$file")"

  rmpc clear >/dev/null

  idx=0
  while IFS= read -r f; do
    [[ -z "$f" || "$f" == "null" ]] && continue
    if [[ $idx -eq 0 ]]; then
      rmpc add "$f" >/dev/null
    else
      rmpc add --position "$idx" "$f" >/dev/null
    fi
    idx=$((idx + 1))
  done < <(jq -r '.queue[].file' "$file")

  # Find the target song's new queue position. Fallback to the saved
  # status.song if we can't match by filename.
  if [[ -n "$song_file" && "$song_file" != "null" ]]; then
    play_pos="$(rmpc queue | jq -r --arg f "$song_file" \
      'map(.file == $f) | index(true) // 0')"
  else
    play_pos="$(jq -r '.status.song // 0' "$file")"
  fi

  rmpc play "$play_pos" >/dev/null
  rmpc seek "$elapsed_secs" >/dev/null

  notify-send -t 3000 "rmpc snapshot restored" "$(jq -r '.label' "$file")"
  echo "Restored snapshot: $file"
}

# ---------- fzf UI ----------

pick_snapshot() {
  # List snapshot files sorted by mtime (newest first). Each fzf entry is
  # "<display>\t<full-path>" so the picker shows just the filename while the
  # preview and delete get the full path.
  local display
  display="$(
    find "$SNAP_DIR" -maxdepth 1 -type f -name '*.json' \
      -printf '%T@\t%f\t%p\n' \
      | sort -rn \
      | cut -f2,3 \
      | fzf \
          --prompt="snapshot > " \
          --delimiter=$'\t' \
          --with-nth=1 \
          --preview="${SCRIPT_DIR}/rmpc_snapshot_preview.sh {2}" \
          --preview-window=right:70%:wrap \
          --bind="del:execute-silent(rm {2})+reload(find $SNAP_DIR -maxdepth 1 -type f -name '*.json' -printf '%T@\t%f\t%p\n' | sort -rn | cut -f2,3)" \
    )"
  # display is "<name>\t<path>" — extract the path (second tab-separated field).
  [[ -n "$display" ]] && printf '%s' "${display#*$'\t'}"
}

choose_action() {
  printf 'Create new snapshot\nRestore a snapshot\n' \
    | fzf --prompt="action > " --no-preview \
    | awk '{print $1}'
}

# ---------- main ----------

# Run an interactive picker loop. Returns to the action menu after each
# operation so the user can chain operations (e.g. snapshot, then restore
# something else). They exit by pressing Esc at the action menu or Ctrl-D.

done_msg() {
  printf '\n%s\n' "$1"
  printf 'Press Enter to close... '
  # Read from /dev/tty so this works even if stdin is piped.
  IFS= read -r _ </dev/tty || true
}

pick_action() {
  choose_action </dev/tty
}

while true; do
  # If the user pressed Ctrl-C (fzf killed by signal), exit immediately
  # without the "Cancelled" prompt. Ctrl-C → fzf exits ~130; Esc → exit 0
  # with empty stdout. Treat any non-zero exit as Ctrl-C.
  if ! action="$(pick_action)"; then
    exit 130
  fi
  if [[ -z "$action" ]]; then
    done_msg "Cancelled."
    exit 0
  fi

  case "$action" in
    [Cc]reate|[Nn]ew|[Ss]ave|s|S)
      printf 'Snapshot name (empty = auto): ' </dev/tty
      IFS= read -r name </dev/tty || name=""
      capture_snapshot "$name"
      printf '\n'
      ;;
    [Rr]estore|[Ll]oad|r|R)
      if ! file="$(pick_snapshot </dev/tty)"; then
        exit 130
      fi
      if [[ -z "$file" ]]; then
        printf 'No snapshot selected.\n'
        printf '\n'
      else
        restore_snapshot "$file"
        exit 0
      fi
      ;;
    *)
      printf 'Unknown action: %s\n' "$action"
      ;;
  esac
done