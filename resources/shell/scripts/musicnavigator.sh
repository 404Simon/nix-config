#!/usr/bin/env bash

mapfile -t music_dirs < <(find ~/Music -type d -not -path '*/\.*' | sed "s|$HOME/Music/||" | grep -v "^$HOME/Music$" | sort)
music_dirs=("Music" "${music_dirs[@]}")

target=$(printf "%s\n" "${music_dirs[@]}" | gum filter)

if [ -z "$target" ]; then
    exit 0
fi

if [ "$target" == "Music" ]; then
    target="$HOME/Music"
else
    target="$HOME/Music/$target"
fi

printf 'cd -- %q\n' "$target"
