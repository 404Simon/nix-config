# Minimal derivation for Laravel Pint (pint.phar), which is not packaged in nixpkgs.
{ pkgs, ... }:
let
  pintPhar = pkgs.fetchurl {
    url = "https://github.com/laravel/pint/releases/download/v1.30.5/pint.phar";
    sha256 = "173751q9mm3ij2qc6y5qn3cpjss9xa3praps5gyjfhz5sz844827";
  };

  pint = pkgs.stdenv.mkDerivation {
    pname = "pint";
    version = "1.30.5";

    src = pintPhar;

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -m 0644 $src $out/bin/pint.phar
      makeWrapper ${pkgs.php}/bin/php $out/bin/pint \
        --add-flags "$out/bin/pint.phar" \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.php ]}

      runHook postInstall
    '';
  };
in
{
  # Provide all formatters declaratively so conform never downloads anything at runtime.
  extraPackages = [
    pint
    pkgs.stylua
    pkgs.prettier
    pkgs.black
    pkgs.isort
    pkgs.nixpkgs-fmt
    pkgs.yamlfmt
  ];

  plugins.conform-nvim = {
    enable = true;

    settings = {
      notify_on_error = false;

      format_on_save.__raw = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end
      '';

      formatters_by_ft = {
        lua = [ "stylua" ];
        go = [
          "gofmt"
          "goimports"
        ];
        php = [ "pint" ];
        tex = [ "tex-fmt" ];
        python = [
          "isort"
          "black"
        ];
        nix = [ "nixpkgs_fmt" ];
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        json = [ "prettier" ];
        jsonc = [ "prettier" ];
        html = [ "prettier" ];
        css = [ "prettier" ];
        yaml = [ "yamlfmt" ];
        markdown = [ "prettier" ];
      };
    };
  };

  userCommands = {
    FormatDisable = {
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end
      '';
      bang = true;
      desc = "Disable autoformat-on-save";
    };
    FormatEnable = {
      command.__raw = ''
        function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end
      '';
      desc = "Re-enable autoformat-on-save";
    };
  };

  keymaps = [
    {
      key = "<leader>f";
      mode = "";
      action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<CR>";
      options.desc = "[F]ormat buffer";
    }
    {
      key = "<leader>tf";
      mode = "";
      action.__raw = ''
        function()
          if vim.b.disable_autoformat then
            vim.cmd("FormatEnable")
            vim.notify("Enabled autoformat for current buffer")
          else
            vim.cmd("FormatDisable!")
            vim.notify("Disabled autoformat for current buffer")
          end
        end
      '';
      options.desc = "Toggle autoformat for current buffer";
    }
    {
      key = "<leader>tF";
      mode = "";
      action.__raw = ''
        function()
          if vim.g.disable_autoformat then
            vim.cmd("FormatEnable")
            vim.notify("Enabled autoformat globally")
          else
            vim.cmd("FormatDisable")
            vim.notify("Disabled autoformat globally")
          end
        end
      '';
      options.desc = "Toggle autoformat globally";
    }
  ];
}
