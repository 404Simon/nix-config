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
