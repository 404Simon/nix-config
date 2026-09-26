#!/usr/bin/env bash

songs=$(rmpc listall)

choice=$(echo "$songs" | wofi --dmenu -i -p "Choose song:")

[ -z "$choice" ] && exit 0

if [ -z "$(rmpc queue)" ]; then
  rmpc add "$choice"
else
  # Relative position needs a current song; when stopped (song=null)
  # it fails with "No current song", so fall back to appending.
  rmpc add --position +0 "$choice" || rmpc add "$choice"
fi
