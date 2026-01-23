{ config, pkgs, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/neovim.nix
    ./modules/git.nix
  ];

  targets.genericLinux.enable = true;

  home.username = "simon";
  home.homeDirectory = "/home/simon";

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
