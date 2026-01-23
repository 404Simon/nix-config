{
  config,
  pkgs,
  lib,
  ...
}:

# needed to change exec path in /usr/share/wayland-sessions/hyprland.desktop to nix managed hyprland binary

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      monitor = [
        "eDP-1,preferred,0x1440,1.0"
        "DP-3,2560x1440@74.97,0x0,1"
        "DP-4,2560x1440@74.97,0x0,1"
        "DP-2,1920x1200@60,0x0,1"
        ",1920x1080,auto,1,mirror,eDP-1"
      ];

      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        kb_options = "ctrl:nocaps";
        numlock_by_default = true;
        repeat_delay = 180;
        repeat_rate = 50;
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.5;
          drag_lock = false;
        };
      };

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      "$terminal" =
        "env GTK_IM_MODULE=ibus XMODIFIERS=@im=ibus ${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true";
      "$browser" = "zen-browser";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      "$mainMod" = "SUPER";
      "$superShift" = "SUPER_SHIFT";

      exec-once = [
        "ironbar & hyprpaper & swaync & hypridle & hyprsunset & nm-applet"
        "~/dev/librepods/linux/build/librepods --hide"
        "$browser"
        "$terminal"
        "vesktop"
        "thunderbird"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "systemctl --user start wallpaper.service"
        "syncthing --no-browser"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = false;
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        vfr = true;
      };

      ecosystem = {
        no_update_news = true;
      };

      bind = [
        "$mainMod, E, exec, $fileManager"
        "$mainMod, space, exec, $menu"

        "$mainMod, A, exec, w=$(hyprctl activeworkspace | head -n1 | grep -o 'ID [0-9]' | cut -d' ' -f2); if [ \"$w\" = \"1\" ]; then $browser; elif [ \"$w\" = \"2\" ]; then $terminal; elif [ \"$w\" = \"4\" ]; then vivaldi; elif [ \"$w\" = \"7\" ]; then thunderbird; elif [ \"$w\" = \"8\" ]; then spotify; elif [ \"$w\" = \"9\" ]; then vesktop; fi"

        # Window management
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$superShift, F, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, N, layoutmsg, togglesplit"

        "$mainMod, B, exec, ironbar bar top toggle-visible"
        "$mainMod, R, exec, nmcli radio wifi \"$(nmcli radio wifi | grep -q 'enabled' && echo 'off' || echo 'on')\""
        "$mainMod, W, exec, systemctl --user start wallpaper.service"
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

        # Lock/suspend
        "$mainMod, L, exec, systemctl suspend"
        "$superShift, l, exec, hyprlock"

        # External display management
        "$mainMod, F1, exec, current=$(brightnessctl g); if [ \"$current\" -gt 0 ]; then brightnessctl s 0; else brightnessctl s 19200; fi"
        "$mainMod, F2, exec, MON=DP-3; MODELINE=\"2560x1440@74.97,0x0,1\"; if hyprctl monitors | grep -q \"$MON\"; then for ws in $(hyprctl workspaces | grep -oP 'workspace ID \\K[0-9]+'); do hyprctl dispatch moveworkspacetomonitor \"$ws eDP-1\"; done; hyprctl keyword monitor \"$MON,disable\"; else hyprctl keyword monitor \"$MON,$MODELINE\"; current=$(hyprctl activeworkspace | grep -oP 'workspace ID \\K[0-9]+'); hyprctl dispatch workspace 10; hyprctl dispatch moveworkspacetomonitor 10 DP-3; hyprctl dispatch workspace $current; for ws in $(hyprctl workspaces | grep -oP 'workspace ID \\K[0-9]'); do hyprctl dispatch moveworkspacetomonitor \"$ws eDP-1\"; done; fi"
        "$mainMod, F3, exec, /home/simon/dotfiles/monitor_workspace_switcher.sh"

        # Screenshots
        ", PRINT, exec, hyprshot -m window -m active"
        "shift, PRINT, exec, hyprshot -m region"
        "ctrl, PRINT, exec, hyprshot -m region"

        # Audio
        "$superShift, a, exec, /home/simon/dotfiles/speaker_switch.sh"
        "$superShift, s, exec, /home/simon/dotfiles/spotify_wofi.sh"
        "$superShift, r, exec, /home/simon/dotfiles/rmpc_wofi.sh"
        "$mainMod, r, exec, /home/simon/dev/rmpc/target/release/rmpc togglepause"
        "$superShift, p, exec, /home/simon/dotfiles/playlist_selection.sh"
        "$mainMod, p, exec, hyprpicker -a"

        # Vim navigation
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ",KP_Delete, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Window rules (old syntax - converted)
      windowrulev2 = [
        # Workspace assignments
        "workspace 1, class:^(zen)$"
        "workspace 2, class:^(com.mitchellh.ghostty)$"
        "workspace 4, class:^(Vivaldi-stable)$"
        "workspace 7, class:^(org.mozilla.Thunderbird)$"
        "workspace 8, class:^(Spotify)$"
        "workspace 9, class:^(vesktop)$"
        "workspace 3, title:^(.*Sweet Home 3D)$"
        "tile, title:^(.*Sweet Home 3D)$"

        # Minecraft
        "workspace 4, class:^(Minecraft|Nomi-CEu).*$"
        "tile, class:^(Minecraft|Nomi-CEu).*$"
      ];
    };
  };

  home.packages = with pkgs; [
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    hyprshot
    hyprsunset
    wofi
    cliphist
    wl-clipboard
    brightnessctl
    playerctl
    networkmanager
  ];
}
