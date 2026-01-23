{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;

      # preload = [
      #   "/home/simon/Bilder/Wallpapers/dark/Grassrivers_03.da407d63.jpg"
      # ];
      #
      # wallpaper = [
      #   ", /home/simon/Bilder/Wallpapers/dark/Grassrivers_03.da407d63.jpg"
      # ];
    };
  };
}
