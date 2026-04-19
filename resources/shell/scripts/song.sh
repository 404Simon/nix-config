#!/usr/bin/env bash

songs="$(rmpc listall)"

selected_song="$(printf '%s\n' "$songs" | fzf --prompt='song > ' --height=80% --reverse)"

if [ -z "${selected_song:-}" ]; then
  exit 0
fi

rmpc add --position +0 "$selected_song"
