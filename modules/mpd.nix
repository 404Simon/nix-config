{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.home.homeDirectory}/Music/mpd/playlists";

    extraConfig = ''
      # Database
      db_file "${config.home.homeDirectory}/Music/mpd/database"

      # Logs and state
      log_file "${config.home.homeDirectory}/.mpd/log"
      state_file "${config.home.homeDirectory}/.mpd/state"
      sticker_file "${config.home.homeDirectory}/.mpd/sticker.sql"

      # Connection
      bind_to_address "${config.home.homeDirectory}/.mpd/socket"

      # Audio Output
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }

      # Input
      input {
        plugin "curl"
      }
    '';
  };

  home.activation.mpdDirectories = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.mpd
    mkdir -p ${config.home.homeDirectory}/Music/mpd/playlists
    mkdir -p ${config.home.homeDirectory}/Music/mpd/lyrics
  '';
}
