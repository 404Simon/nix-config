{
  plugins = {
    mini-ai = {
      enable = true;
      settings.n_lines = 500;
    };

    mini-icons.enable = true;

    mini-statusline = {
      enable = true;
      settings.use_icons = true;
    };
  };

  # Keep `%2l:%-2v` style location like the old config.
  extraConfigLua = ''
    local statusline = require("mini.statusline")
    statusline.section_location = function()
      return "%2l:%-2v"
    end
  '';
}
