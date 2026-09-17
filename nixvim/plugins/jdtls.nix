{ pkgs, ... }:
{
  # JDK 21 runs eclipse.jdt.ls (required); maven/gradle let it import projects.
  # jdt-language-server itself is added by nixvim's jdtls module via
  # `plugins.jdtls.jdtLanguageServerPackage`.
  extraPackages = with pkgs; [
    jdk21
    maven
    gradle
  ];

  plugins.jdtls = {
    enable = true;

    settings = {
      cmd = [
        "jdtls"
        "-data"
        {
          # Per-project workspace, derived from the project root of the
          # current buffer (not cwd, which may be anywhere).
          __raw = ''(function()
            local markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle", "settings.gradle", "settings.gradle.kts" }
            local root = vim.fs.root(0, markers) or vim.fn.getcwd()
            local name = vim.fn.fnamemodify(root, ":t")
            if name == "" or name == nil then
              name = "default"
            end
            return vim.fn.expand("~/.cache/jdtls/workspace/") .. name
          end)()'';
        }
      ];

      # NOTE: must evaluate to a STRING, not a function. Neovim 0.11's
      # vim.lsp.start() derives workspaceFolders from root_dir and cannot
      # handle a function here (a function root silently yields no workspace,
      # hence "No workspace folders or root uri was defined" + every file
      # reported as "non-project file"). The IIFE below runs at FileType
      # time, when the current buffer is the java file just opened.
      root_dir.__raw = ''
        (function()
          local markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle", "settings.gradle", "settings.gradle.kts" }
          local root = vim.fs.root(0, markers)
          if root == "" or root == nil then
            return vim.fn.getcwd()
          end
          return root
        end)()
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

  # nvim-jdtls extras from upstream README (no nvim-dap dependency).
  # Generic LSP maps (K, gd, gr, ca, <space>rn) come from lsp.nix via LspAttach.
  keymaps = [
    {
      mode = "n";
      key = "<A-o>";
      action.__raw = "function() require('jdtls').organize_imports() end";
      options.desc = "jdtls: organize imports";
    }
    {
      mode = "n";
      key = "crv";
      action.__raw = "function() require('jdtls').extract_variable() end";
      options.desc = "jdtls: extract variable";
    }
    {
      mode = "v";
      key = "crv";
      action.__raw = "function() require('jdtls').extract_variable(true) end";
      options.desc = "jdtls: extract variable (visual)";
    }
    {
      mode = "n";
      key = "crc";
      action.__raw = "function() require('jdtls').extract_constant() end";
      options.desc = "jdtls: extract constant";
    }
    {
      mode = "v";
      key = "crc";
      action.__raw = "function() require('jdtls').extract_constant(true) end";
      options.desc = "jdtls: extract constant (visual)";
    }
    {
      mode = "v";
      key = "crm";
      action.__raw = "function() require('jdtls').extract_method(true) end";
      options.desc = "jdtls: extract method (visual)";
    }
  ];
}
