{
  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
      transparent = true;
      styles = {
        sidebars = "transparent";
        floats = "transparent";
      };
    };
  };

  userCommands = {
    Day = {
      command.__raw = ''
        function(args)
          require("tokyonight").setup({ style = "day", transparent = false })
          vim.cmd("colorscheme tokyonight-day")
        end
      '';
    };
    Night = {
      command.__raw = ''
        function(args)
          require("tokyonight").setup({
            style = "night",
            transparent = true,
            styles = { sidebars = "transparent", floats = "transparent" },
          })
          vim.cmd("colorscheme tokyonight-night")
        end
      '';
    };
  };
}
