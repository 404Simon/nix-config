{
  config,
  pkgs,
  nixGLPkgs,
  ...
}:

{
  programs.ghostty = {
    enable = true;

    package = pkgs.symlinkJoin {
      name = "ghostty";
      paths = [ pkgs.ghostty ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
                # Remove old binary
                rm $out/bin/ghostty

                # Create wrapper script
                cat > $out/bin/ghostty <<'EOF'
        #!/usr/bin/env bash
        exec ${nixGLPkgs.nixGLIntel}/bin/nixGLIntel ${pkgs.ghostty}/bin/ghostty "$@"
        EOF
                chmod +x $out/bin/ghostty

                # Fix desktop file to point to wrapper
                if [ -f $out/share/applications/com.mitchellh.ghostty.desktop ]; then
                  rm $out/share/applications/com.mitchellh.ghostty.desktop
                  substitute ${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop \
                    $out/share/applications/com.mitchellh.ghostty.desktop \
                    --replace-fail "${pkgs.ghostty}/bin/ghostty" "$out/bin/ghostty"
                fi
      '';
    };

    settings = {
      theme = "TokyoNight";
      background-opacity = 0.90;
      background-blur-radius = 20;
      macos-non-native-fullscreen = true;
      gtk-titlebar = false;
      font-family = "JetBrains Mono Nerd Font Mono";
    };
  };
}
