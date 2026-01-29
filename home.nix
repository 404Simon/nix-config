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
    ./modules/ironbar.nix
    ./modules/opencode.nix
    ./modules/mpd.nix
    ./modules/rmpc.nix
    ./modules/mpv.nix
    ./modules/qutebrowser.nix
    ./modules/xdg.nix
    ./modules/wallpaper-slideshow.nix
    ./modules/zathura.nix
  ];

  nixpkgs.config.allowUnfree = true;

  targets.genericLinux.enable = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 10d";
    persistent = true;
  };

  home.username = "simon";
  home.homeDirectory = "/home/simon";

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
