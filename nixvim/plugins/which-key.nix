{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      spec = [
        {
          __unkeyed-1 = "<leader>?";
          __unkeyed-2 = "<cmd>WhichKey<cr>";
          desc = "Show All Keybindings";
          mode = "n";
        }
      ];
    };
  };
}
