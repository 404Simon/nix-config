{ pkgs, nixGLPkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    jq
    eza
    zoxide
    lazysql
    nixfmt-rfc-style # Nix formatter for nil LSP
    nil # Nix LSP server
    python3
    nodejs
    go
    rustup # includes cargo
    php
    phpPackages.composer
    yazi
    mpv
    rmpc

    # Ghostty
    (pkgs.symlinkJoin {
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
    })

    # Uni
    eduvpn-client
    networkmanager-openvpn
    texlive.combined.scheme-full
    typst

    calcure
    newsboat
    socat
  ];
}
