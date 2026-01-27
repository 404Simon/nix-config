{ config, pkgs, ... }:

let
  wallpaperConfig = import ./wallpaper-config.nix;
in
{
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Changes the Wallpaper";
    };

    Service = {
      Type = "oneshot";
      Environment = [
        "WALLPAPER_DIR=${wallpaperConfig.wallpaperDir}"
        "WALLPAPER_HISTORY_LOG=${wallpaperConfig.wallpaperHistoryLog}"
        "WALLPAPER_CACHE_DB=${wallpaperConfig.wallpaperCacheDb}"
      ];
      ExecStart = ''/bin/bash -c 'WALLPAPER=$(/home/simon/dev/wallpaper_slideshow/target/release/wallpaper_slideshow | tail -n1) && hyprctl hyprpaper preload "$WALLPAPER" && hyprctl hyprpaper wallpaper ",$WALLPAPER"' '';
    };
  };

  systemd.user.timers.wallpaper = {
    Unit = {
      Description = "Change Wallpaper every 15 minutes";
    };

    Timer = {
      OnBootSec = "2min";
      OnUnitActiveSec = "15min";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
