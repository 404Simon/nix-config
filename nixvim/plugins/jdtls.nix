{
  plugins.jdtls = {
    enable = true;

    settings = {
      cmd = [ "jdtls" ];

      root_dir.__raw = ''
        function()
          local markers = { "gradlew", ".git", "mvnw", "pom.xml", "build.gradle", "settings.gradle" }
          local root = require("jdtls.setup").find_root(markers)
          if root == "" or root == nil then
            return vim.fn.getcwd()
          end
          return root
        end
      '';

      capabilities.__raw = "vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())";

      settings = {
        java = {
          eclipse = {
            downloadSources = true;
          };
          configuration = {
            updateBuildConfiguration = "interactive";
          };
          maven = {
            downloadSources = true;
          };
          implementationsCodeLens = {
            enabled = true;
          };
          referencesCodeLens = {
            enabled = true;
          };
          references = {
            includeDecompiledSources = true;
          };
          inlayHints = {
            parameterNames = {
              enabled = "all";
            };
          };
          contentProvider = {
            preferred = "fernflower";
          };
        };
      };

      init_options = {
        extendedClientCapabilities.__raw = ''
          (function()
            local extended = require("jdtls").extendedClientCapabilities
            extended.resolveAdditionalTextEditsSupport = true
            return extended
          end)()
        '';
      };
    };
  };
}
