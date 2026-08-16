{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = false;

      settings = {
        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };

        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
        };

        sources = [
          { name = "nvim_lsp"; }
          {
            name = "buffer";
            group_index = 2;
          }
        ];
      };
    };

    cmp-nvim-lsp.enable = true;
  };
}
