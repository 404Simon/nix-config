{
  plugins.snacks = {
    enable = true;

    settings = {
      bigfile.enabled = true;

      dashboard = {
        enabled = true;
        # Drop the `startup` section: it requires lazy.nvim (`lazy.stats`), which
        # nixvim doesn't provide. Keys, header and pickers are enough.
        sections = [
          {
            section = "header";
          }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
        preset = {
          keys = [
            {
              icon = "  ";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.dashboard.pick('files')";
            }
            {
              icon = "  ";
              key = "n";
              desc = "New File";
              action = ":ene | startinsert";
            }
            {
              icon = "";
              key = "N";
              desc = "New Note";
              action.__raw = "function() require('utils.obsidian').create_new_note() end";
            }
            {
              icon = "  ";
              key = "m";
              desc = "Find Modul";
              action.__raw = "function() Snacks.picker.files({ pattern = 'Modul ' }) end";
            }
            {
              icon = "";
              key = "j";
              desc = "Todays Journal";
              action.__raw = "function() require('utils.obsidian').create_todays_journal_entry() end";
            }
            {
              icon = "  ";
              key = "g";
              desc = "Grep";
              action = ":lua Snacks.dashboard.pick('live_grep')";
            }
            {
              icon = "  ";
              key = "r";
              desc = "Recent Files";
              action = ":lua Snacks.dashboard.pick('oldfiles')";
            }
            {
              icon = "  ";
              key = "c";
              desc = "Config";
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})";
            }
            {
              icon = "  ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
        };
      };

      indent.enabled = true;
      input.enabled = true;
      git.enabled = true;
      picker.enabled = true;
      notifier.enabled = true;
      quickfile.enabled = true;
      scroll.enabled = false;
      statuscolumn.enabled = true;
      words.enabled = true;
    };
  };

  keymaps = [
    {
      key = "<leader>sf";
      action.__raw = "function() Snacks.picker.pick('files') end";
      options.desc = "Search Files";
    }
    {
      key = "<leader>sm";
      action.__raw = "function() Snacks.picker.files({ pattern = 'Modul ' }) end";
      options.desc = "Search Modul";
    }
    {
      key = "<leader>sr";
      action.__raw = "function() Snacks.picker.recent() end";
      options.desc = "Search Recent";
    }
    {
      key = "<leader><leader>";
      action.__raw = "function() Snacks.picker.buffers() end";
      options.desc = "Buffers";
    }
    {
      key = "<leader>sg";
      action.__raw = "function() Snacks.picker.grep() end";
      options.desc = "Search Grep";
    }
    {
      key = "<leader>ss";
      action.__raw = "function() Snacks.picker.lsp_symbols() end";
      options.desc = "Document Symbols";
    }
    {
      key = "<leader>sS";
      action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
      options.desc = "Workspace Symbols";
    }
  ];
}
