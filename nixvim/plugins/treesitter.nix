{
  pkgs,
  ...
}:
{
  plugins.treesitter = {
    enable = true;
    nixGrammars = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      html
      css
      json
      lua
      php
      rust
      python
      java
      markdown
      typst
      latex
      nix
    ];

    settings.highlight.enable = true;
  };
}
