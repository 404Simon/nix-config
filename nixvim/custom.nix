{ lib, ... }:
let
  nvimFiles = {
    "lua/utils/obsidian.lua" = ./lua/utils/obsidian.lua;
    "lua/utils/todo_events.lua" = ./lua/utils/todo_events.lua;
    "lua/utils/custom.lua" = ./lua/utils/custom.lua;
    "lua/utils/markdown.lua" = ./lua/utils/markdown.lua;
    "after/ftplugin/markdown.lua" = ./after/ftplugin/markdown.lua;
    "after/ftplugin/tex.lua" = ./after/ftplugin/tex.lua;
  };
in
{
  extraFiles = lib.mapAttrs (_: path: { source = path; }) nvimFiles;

  extraConfigLuaPre = ''
    require("utils.todo_events").setup()
    require("utils.markdown").setup()
  '';

  autoGroups.quickfix.clear = true;

  autoCmd = [
    {
      event = "FileType";
      pattern = "qf";
      group = "quickfix";
      callback.__raw = "function() require('utils.custom').setup_qf_maps() end";
    }
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>q";
      action.__raw = "function() require('utils.custom').toggle_qf() end";
      options.desc = "Toggle quickfix list";
    }
    {
      mode = "n";
      key = "<leader>fm";
      action.__raw = "function() require('utils.custom').find_nonascii_current() end";
      options.desc = "Find non-ASCII in current text buffer";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action.__raw = "function() require('utils.custom').find_nonascii_workspace() end";
      options.desc = "Find non-ASCII in workspace text files";
    }
    {
      mode = "n";
      key = "<leader>tb";
      action.__raw = "function() require('utils.custom').toggle_bool() end";
      options.desc = "Toggle boolean under cursor (True/False)";
    }
    {
      mode = "n";
      key = "<C-n>";
      action.__raw = "function() require('utils.custom').qf_next() end";
      options.desc = "Next quickfix item";
    }
    {
      mode = "n";
      key = "<C-p>";
      action.__raw = "function() require('utils.custom').qf_prev() end";
      options.desc = "Previous quickfix item";
    }
  ];
}
