{ config, pkgs, ... }:

{
  programs.sioyek = {
    enable = true;
    bindings = {
      "toggle_presentation_mode" = "p";
    };
  };
}
