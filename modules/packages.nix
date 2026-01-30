{ pkgs, pkgs-unstable, ... }:

{
  home.packages =
    (with pkgs; [
      vivaldi
      ungoogled-chromium
      kdePackages.dolphin
      imagemagick
      rsync
      restic
      diceware
      wakeonlan
      exiftool
      zip
      unzip
      ripgrep
      fd
      fwupd
      yt-dlp
      poppler-utils
      ffmpeg-full
      feh
      gum
      jq
      tldr
      fastfetch
      subfinder
      vesktop
      ncdu
      mise
      lazysql
      lazydocker
      nixfmt-rfc-style # Nix formatter for nil LSP
      nil # Nix LSP server
      python3
      nodejs
      go
      uv
      rustup # includes cargo
      php
      phpPackages.composer
      yazi
      keepassxc
      zapzap

      # Uni
      eduvpn-client
      networkmanager-openvpn
      texlive.combined.scheme-full
      pandoc
      typst
      obsidian
      onlyoffice-desktopeditors
      anki
      zotero

      calcure
      newsboat
      socat
      sweethome3d.application

      # Gaming
      moonlight-qt
    ])
    ++ (with pkgs-unstable; [
      pangolin-cli
    ]);
}
