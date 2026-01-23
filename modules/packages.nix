{ pkgs, nixGLPkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    jq
    eza
    zoxide
    lazysql
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

    # Uni
    eduvpn-client
    networkmanager-openvpn
    texlive.combined.scheme-full
    typst

    calcure
    newsboat
    socat
  ];
}
