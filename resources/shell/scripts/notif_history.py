#!/usr/bin/env python3
"""Pretty-print mako's notification history (incl. bodies) from D-Bus."""

import argparse
import json
import os
import shutil
import subprocess
import sys
import time

BUSCTL = [
    "busctl",
    "--user",
    "call",
    "org.freedesktop.Notifications",
    "/fr/emersion/Mako",
    "fr.emersion.Mako",
    "ListHistory",
    "--json=short",
]
MAKO_PROC = r"bin/mako$"

ANSI = {
    "reset": "\033[0m",
    "dim": "\033[2m",
    "bold": "\033[1m",
    "red": "\033[31m",
}
APP_COLORS = [
    "\033[36m",
    "\033[32m",
    "\033[33m",
    "\033[34m",
    "\033[35m",
    "\033[96m",
    "\033[92m",
    "\033[93m",
]
URGENCY = {
    "0": ("low", ANSI["dim"], "·"),
    "1": ("normal", "", " "),
    "255": ("critical", ANSI["red"], "!"),
}


def fetch_history():
    try:
        out = subprocess.run(BUSCTL, capture_output=True, text=True, check=True).stdout
    except FileNotFoundError:
        sys.exit("error: busctl not found")
    except subprocess.CalledProcessError as e:
        sys.exit(f"error: could not query mako: {e.stderr.strip()}")
    entries = []
    for raw in json.loads(out)["data"][0]:
        e = {k: v["data"] for k, v in raw.items()}
        entries.append(
            {
                "id": int(e.get("id", 0)),
                "app": e.get("app-name") or e.get("desktop-entry") or "?",
                "summary": e.get("summary", ""),
                "body": e.get("body", "").strip(),
                "urgency": int(e.get("urgency") or 0),
                "actions": (
                    e.get("actions", {}) if isinstance(e.get("actions"), dict) else {}
                ),
            }
        )
    return entries


def render(entries, c, actions, app_width):
    lines = []
    for e in entries:
        _, ucolor, mark = URGENCY.get(str(e["urgency"]), ("normal", "", " "))
        r = ANSI["reset"] if c else ""
        acolor = APP_COLORS[hash(e["app"]) % len(APP_COLORS)] if c else ""
        head = (
            f"{ucolor if c else ''}{mark}{r} "
            f"{c_dim(str('#' + str(e['id'])).ljust(5), c)} "
            f"{acolor}{e['app'][:app_width]:<{app_width}}{r} "
        )
        lines.append((head + f"{e['summary']}").rstrip())
        indent = " " * (8 + app_width)
        for bline in e["body"].splitlines():
            lines.append(c_dim(indent + bline, c))
        if actions:
            for aname, alabel in e["actions"].items():
                lines.append(c_dim(f"{indent}↳ {alabel} [{aname}]", c))
        lines.append("")
    return "\n".join(lines)


def c_dim(s, c):
    return f"{ANSI['dim']}{s}{ANSI['reset']}" if c else s


def clear_history():
    if subprocess.run(["pgrep", "-f", MAKO_PROC], capture_output=True).returncode != 0:
        print("mako is not running, nothing to clear")
        return
    subprocess.run(["pkill", "-f", MAKO_PROC], check=False)
    for _ in range(50):
        time.sleep(0.1)
        r = subprocess.run(BUSCTL, capture_output=True, text=True)
        if r.returncode == 0 and json.loads(r.stdout)["data"][0] == []:
            print("notification history cleared")
            return
    sys.exit("error: mako did not come back after restart")


def main():
    p = argparse.ArgumentParser(
        description="Nicely formatted mako notification history."
    )
    p.add_argument(
        "command",
        nargs="?",
        choices=["clear"],
        help="'clear' empties the history (restarts the mako daemon)",
    )
    p.add_argument(
        "-n",
        "--limit",
        type=int,
        default=30,
        help="show N most recent (0 = all, default: 30)",
    )
    p.add_argument("-a", "--app", help="filter by app name substring")
    p.add_argument("-s", "--search", help="filter by summary/body substring")
    p.add_argument(
        "-u",
        "--urgency",
        choices=["low", "normal", "critical"],
        help="filter by urgency",
    )
    p.add_argument(
        "-r",
        "--reverse",
        action="store_true",
        help="oldest first instead of newest first",
    )
    p.add_argument(
        "-A", "--actions", action="store_true", help="also show notification actions"
    )
    p.add_argument("--no-color", action="store_true", help="disable colored output")
    args = p.parse_args()

    if args.command == "clear":
        clear_history()
        return

    entries = fetch_history()
    if args.app:
        entries = [e for e in entries if args.app.lower() in e["app"].lower()]
    if args.search:
        entries = [
            e
            for e in entries
            if args.search.lower() in (e["summary"] + " " + e["body"]).lower()
        ]
    if args.urgency:
        code = {"low": 0, "normal": 1, "critical": 255}[args.urgency]
        entries = [e for e in entries if e["urgency"] == code]

    shown = entries[: args.limit] if args.limit else entries
    if args.reverse:
        shown = list(reversed(shown))

    if not shown:
        print("no notifications in history")
        return

    c = sys.stdout.isatty() and not args.no_color and os.environ.get("TERM") != "dumb"
    app_width = min(max((len(e["app"]) for e in shown), default=10), 20)
    out = render(shown, c, args.actions, app_width)

    if sys.stdout.isatty() and out.count("\n") >= shutil.get_terminal_size().lines:
        subprocess.run(["less", "-R", "-F"], input=out.encode())
    else:
        sys.stdout.write(out)


if __name__ == "__main__":
    main()
