#!/usr/bin/env bash
# Fuzzy emoji picker (wofi): copies to clipboard and types into the focused app.

list_candidates=(
  "$XDG_DATA_HOME/emoji-picker/emoji.txt"
  "$HOME/.local/share/emoji-picker/emoji.txt"
)

emoji_file=""
for f in "${list_candidates[@]}"; do
  if [ -f "$f" ]; then
    emoji_file="$f"
    break
  fi
done

[ -z "$emoji_file" ] && notify-send -t 3000 "emoji-picker" "no emoji list found" && exit 1

wofi_args=(--dmenu -i -p "Emoji:")
style_file="${XDG_CONFIG_HOME:-$HOME/.config}/wofi/emoji.css"
[ -f "$style_file" ] && wofi_args+=(--style "$style_file")

choice=$(wofi "${wofi_args[@]}" < "$emoji_file")

[ -z "$choice" ] && exit 0

# First field is the emoji (may be multi-codepoint: ZWJ sequences, skin tones).
emoji=$(echo "$choice" | awk '{print $1}')
[ -z "$emoji" ] && exit 0

printf '%s' "$emoji" | wl-copy
if command -v wtype >/dev/null 2>&1; then
  wtype -- "$emoji" || true
fi
