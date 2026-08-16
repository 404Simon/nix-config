{ config, pkgs, nixvim, typst-preview, ... }:

{
  imports = [
    nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    imports = [
      ../nixvim
    ];

    # typst-preview.nvim from the local dev checkout (native webview branch).
    # NOTE: machine-specific input; the future NixOS repo should use the
    # released plugin or a pinned fetch instead.
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "typst-preview.nvim";
        src = typst-preview;
      })
    ];
  };
}
