{ config, pkgs, ... }:

{
  targets.genericLinux.enable = true;
  home.username = "simon";
  home.homeDirectory = "/home/simon";

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    git

    # uni stuff
    eduvpn-client
    networkmanager-openvpn
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/nvim";
  
  programs.home-manager.enable = true;

  home.stateVersion = "25.11"; 
}
