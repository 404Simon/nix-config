{
  lib,
  pkgs,
  ...
}:
{
  filetype.extension.typst = "typst";

  autoGroups.typst-preview.clear = true;

  autoCmd = [
    {
      event = "FileType";
      pattern = "typst";
      callback.__raw = ''
        function()
          vim.keymap.set("n", "<leader>p", "<cmd>TypstPreview<CR>", { buffer = 0 })
          vim.opt_local.formatoptions:append("t")
          vim.opt_local.linebreak = true
          vim.opt_local.wrap = true
        end
      '';
    }
  ];

  extraConfigLua = ''
    require("typst-preview").setup({
      use_native_webview = true,
      dependencies_bin = {
        tinymist = ${builtins.toJSON (lib.getExe pkgs.tinymist)},
        websocat = ${builtins.toJSON (lib.getExe pkgs.websocat)},
      },
    })
  '';
}
