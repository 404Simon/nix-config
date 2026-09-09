{ pkgs, ... }:

let
  emojibaseVersion = "17.0.0";

  deCompact = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/emojibase-data@${emojibaseVersion}/de/compact.json";
    hash = "sha256-IAWl4FUDpgv7jJTQnM8jImza9E9aAcxRAGqOz60h/Ac=";
  };

  enCompact = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/npm/emojibase-data@${emojibaseVersion}/en/compact.json";
    hash = "sha256-HHz1OTKFY3Q8Kyrf9xF8z/CuaFLVkTZvQ2P1BQPV45g=";
  };

  # One line per emoji: "<emoji> <merged DE/EN labels, tags, shortcodes>".
  emojiList = pkgs.runCommand "emoji-list.txt" { } ''
    ${pkgs.python3}/bin/python3 - <<'PY'
    import json
    import os

    with open("${deCompact}") as f:
        de = json.load(f)
    with open("${enCompact}") as f:
        en = json.load(f)
    en_by_hex = {e["hexcode"]: e for e in en}

    def merge_one(de_e, en_e):
        unicode = de_e.get("unicode") or (en_e or {}).get("unicode") or ""
        if not unicode:
            return None
        en_e = en_e or {}
        seen = set()
        words = []
        for label in (de_e.get("label", ""), en_e.get("label", "")):
            if label and label.lower() not in seen:
                seen.add(label.lower())
                words.append(label)
        for lst in (
            de_e.get("tags", []),
            en_e.get("tags", []),
            de_e.get("shortcodes", []),
            en_e.get("shortcodes", []),
            de_e.get("emoticon", []),
            en_e.get("emoticon", []),
        ):
            for t in lst:
                if t and t.lower() not in seen:
                    seen.add(t.lower())
                    words.append(t)
        order = de_e.get("order", 999999)
        return (order, f"{unicode} {' '.join(words)}\n")

    rows = []
    for de_e in de:
        en_e = en_by_hex.get(de_e.get("hexcode", ""))
        base = merge_one(de_e, en_e)
        if base:
            rows.append(base)
        en_skins = {s["hexcode"]: s for s in (en_e or {}).get("skins", [])} if en_e else {}
        for s in de_e.get("skins", []):
            r = merge_one(s, en_skins.get(s.get("hexcode", "")))
            if r:
                rows.append(r)

    rows.sort(key=lambda r: r[0])
    with open(os.environ["out"], "w", encoding="utf-8") as f:
        for _, line in rows:
            f.write(line)
    print(f"{len(rows)} emojis written")
    PY
  '';
in
{
  xdg.dataFile."emoji-picker/emoji.txt".source = emojiList;

  # Stylesheet for the emoji picker only (other wofi menus stay default).
  xdg.configFile."wofi/emoji.css".source = ../resources/wofi/emoji.css;

  home.packages = with pkgs; [
    wtype # type into the focused app
    noto-fonts-color-emoji # render emojis in wofi
  ];
}
