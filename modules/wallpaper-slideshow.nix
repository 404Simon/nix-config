{ config, pkgs, ... }:

let
  wallpaperConfig = import ./wallpaper-config.nix;
in
{
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Changes the Wallpaper";
      After = [
        "graphical-session.target"
        "hyprpaper.service"
      ];
      Requires = [ "hyprpaper.service" ];
    };

    Service = {
      Type = "oneshot";
      Environment = [
        "WALLPAPER_DIR=${wallpaperConfig.wallpaperDir}"
        "WALLPAPER_HISTORY_LOG=${wallpaperConfig.wallpaperHistoryLog}"
        "WALLPAPER_CACHE_DB=${wallpaperConfig.wallpaperCacheDb}"
      ];
      ExecStart = ''/bin/bash -c 'for i in {1..5}; do WALLPAPER=$(/home/simon/dev/wallpaper_slideshow/target/release/wallpaper_slideshow | tail -n1) && hyprctl hyprpaper preload "$WALLPAPER" && hyprctl hyprpaper wallpaper ",$WALLPAPER" && exit 0 || sleep 1; done; exit 1' '';
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.timers.wallpaper = {
    Unit = {
      Description = "Change Wallpaper every 15 minutes";
    };

    Timer = {
      OnUnitActiveSec = "15min";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
