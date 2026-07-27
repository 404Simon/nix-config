#!/usr/bin/env bash

ICON="$HOME/Pictures/pumpkin.png"
ENV="DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus XDG_RUNTIME_DIR=/run/user/$(id -u)"
PLAY="/usr/share/sounds/freedesktop/stereo/complete.oga"

case "$1" in
  work)
    minutes="${2:-25}"
    rmpc play
    systemd-run --user --on-active="${minutes}m" --unit="work-timer-$$" --quiet --collect \
      bash -c "rmpc pause; env $ENV notify-send -i '$ICON' 'Work Timer is up! Take a Break 😊' 'Santa 🎅🏼'; paplay '$PLAY' 2>/dev/null; paplay '$PLAY' 2>/dev/null"
    ;;
  list)
    output=$(systemctl --user list-timers 2>/dev/null | grep -E '(NEXT|timer-|work-timer-|break-timer-)')
    if [ -z "$output" ]; then
      echo "No active timers."
    else
      echo "$output"
    fi
    ;;
  break|chill)
    minutes="${2:-7}"
    systemd-run --user --on-active="${minutes}m" --unit="break-timer-$$" --quiet --collect \
      bash -c "env $ENV notify-send -i '$ICON' 'Break is over! Get back to work 😬' 'Santa 🎅🏼'; paplay '$PLAY' 2>/dev/null; paplay '$PLAY' 2>/dev/null"
    ;;
  *)
    minutes="$1"
    if [ -z "$minutes" ]; then
      echo "Usage: timer <minutes> | timer work [minutes] | timer break [minutes]" >&2
      exit 1
    fi
    if ! [[ "$minutes" =~ ^[0-9]+$ ]]; then
      echo "timer: unknown command '$minutes'. Try 'timer work' or 'timer break'." >&2
      exit 1
    fi
    systemd-run --user --on-active="${minutes}m" --unit="timer-$$" --quiet --collect \
      bash -c "env $ENV notify-send -i '$ICON' 'Timer' \"Time's up! (${minutes}m)\" -u critical; paplay '$PLAY' 2>/dev/null; paplay '$PLAY' 2>/dev/null"
    ;;
esac
