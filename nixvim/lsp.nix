{ lib, ... }:

{
  plugins.lspconfig.enable = true;

  lsp = {
    # Enable inlay hints per-buffer on LspAttach (nixvim's `inlayHints.enable`
    # only enables them for the first buffer at startup).
    onAttach = ''
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    '';

    servers."*".config = {
      capabilities.__raw = "vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())";
    };

    servers = {
      clangd.enable = true;

      docker_compose_language_service.enable = true;

      dockerls.enable = true;

      gopls.enable = true;

      jsonls.enable = true;

      lua_ls = {
        enable = true;
        config.settings.Lua = {
          hint = {
            enable = true;
            setType = false;
            paramType = true;
            paramName = "Disable";
            semicolon = "Disable";
            arrayIndex = "Disable";
          };
        };
      };

      marksman.enable = true;

      nil_ls.enable = true;

      ols.enable = true;

      phpactor.enable = true;

      stimulus_ls.enable = true;

      pyrefly = {
        enable = true;
        config.on_attach.__raw = ''
          function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        '';
      };

      ruff = {
        enable = true;
        config.on_attach.__raw = ''
          function(client, bufnr)
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.documentSymbolProvider = false
            client.server_capabilities.completionProvider = false
            client.server_capabilities.hoverProvider = false
          end
        '';
      };

      tailwindcss.enable = true;

      texlab.enable = true;

      tinymist.enable = true;

      tsgo.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "K";
        lspBufAction = "hover";
      }
      {
        mode = "n";
        key = "gd";
        lspBufAction = "definition";
      }
      {
        mode = "n";
        key = "gr";
        lspBufAction = "references";
      }
      {
        mode = "n";
        key = "ca";
        lspBufAction = "code_action";
      }
      {
        mode = "n";
        key = "<space>rn";
        lspBufAction = "rename";
      }
      {
        mode = "n";
        key = "<leader>th";
        action.__raw = ''
          function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
            vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
          end
        '';
        options.desc = "Toggle inlay hints";
      }
    ];
  };
}
