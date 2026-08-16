{
  plugins = {
    obsidian = {
      enable = true;
      settings = {
        legacy_commands = false;
        frontmatter.enabled = false;
        workspaces = [
          {
            name = "personal";
            path.__raw = "os.getenv('OBSIDIAN_VAULT') or '~/obsidian-vault'";
          }
        ];
        ui.enable = false;
      };
    };

    render-markdown = {
      enable = true;
      settings = {
        heading = {
          icons = [ "✱ " "✲ " "✤ " "✣ " "✸ " "✳ " ];
          backgrounds = [ "RMdH1" "RMdH2" "RMdH3" "RMdH4" "RMdH5" "RMdH6" ];
        };
        latex = {
          enabled = false;
          converter = "latex2text";
          highlight = "RenderMarkdownMath";
          top_pad = 0;
          bottom_pad = 1;
        };
        code = {
          sign = false;
          left_pad = 1;
        };
        quote.icon = "┃";
        pipe_table = {
          enabled = true;
          preset = "round";
          style = "full";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>so";
      action = "<cmd>Obsidian open<CR>";
      options.desc = "Open the file in Obsidian";
    }
  ];
}
