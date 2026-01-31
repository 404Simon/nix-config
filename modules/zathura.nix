{ config, pkgs, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
    mappings = {
      "<Right>" = "navigate next";
      "<Left>" = "navigate previous";
      "y" = ''exec "sh -c 'pdftoppm -f $PAGE -l $PAGE -png \"$FILE\" | wl-copy'"'';
    };
  };

  home.packages = [
    pkgs.poppler-utils
    pkgs.wl-clipboard
  ];
}
