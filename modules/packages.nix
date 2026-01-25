{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vivaldi
    zip
    unzip
    ripgrep
    fd
    fzf
    jq
    tldr
    vesktop
    ncdu
    eza
    zoxide
    mise
    lazysql
    lazydocker
    nixfmt-rfc-style # Nix formatter for nil LSP
    nil # Nix LSP server
    python3
    nodejs
    go
    rustup # includes cargo
    php
    phpPackages.composer
    yazi
    mpv
    rmpc
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

    calcure
    newsboat
    socat
    sweethome3d.application

    # Gaming
    moonlight-qt
    steam
  ];
}
