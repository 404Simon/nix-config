{ pkgs, pkgs-unstable, pdf-extract, ... }:

{
  home.packages =
    (with pkgs; [
      (vivaldi.override { proprietaryCodecs = true; })
      ungoogled-chromium
      kdePackages.dolphin
      kdePackages.kdenlive
      imagemagick
      rsync
      croc
      restic
      audacity
      localsend
      pdftk
      pdfchain
      pdf-extract
      diceware
      wakeonlan
      exiftool
      zip
      unzip
      unrar-free
      ripgrep
      dufs
      fd
      fwupd
      poppler-utils
      ffmpeg-full
      feh
      gum
      jq
      tldr
      fastfetch
      subfinder
      fluffychat
      ncdu
      mise
      lazysql
      lazydocker
      nixfmt-rfc-style # Nix formatter for nil LSP
      nil # Nix LSP server
      nodejs
      go
      uv
      apptainer
      rustup # includes cargo
      php
      phpPackages.composer
      pnpm
      yazi
      keepassxc
      zapzap
      vesktop
      obs-studio
      radicle-node
      wl-clipboard-rs

      chess-tui

      # Uni
      eduvpn-client
      networkmanager-openvpn
      texlive.combined.scheme-full
      pandoc
      typst
      plantuml
      apostrophe
      obsidian
      onlyoffice-desktopeditors
      libreoffice
      anki
      zotero
      xournalpp
      xlsx2csv

      calcure
      newsboat
      socat
      sweethome3d.application

      # Gaming
      moonlight-qt

      # Photography
      kdePackages.gwenview
      rawtherapee
      inkscape

      # python with global packages
      (pkgs.python3.withPackages (
        ps: with ps; [
          pylatexenc
        ]
      ))
    ])
    ++ (with pkgs-unstable; [
      pangolin-cli
      librepods
      mixxx
      codex
      vscode
      tabiew
      tex-fmt
      just
      yt-dlp
      gimp
      bun
      signal-desktop
    ]);
}
