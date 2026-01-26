{ config, pkgs, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/ghostty.nix
    ./modules/hyprland.nix
    ./modules/opencode.nix
    ./modules/mpd.nix
    ./modules/rmpc.nix
    ./modules/mpv.nix
    ./modules/qutebrowser.nix
    ./modules/xdg.nix
  ];

  nixpkgs.config.allowUnfree = true;

  targets.genericLinux.enable = true;

  home.username = "simon";
  home.homeDirectory = "/home/simon";

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
