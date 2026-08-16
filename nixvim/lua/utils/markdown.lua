-- render-markdown heading highlights (tokyonight palette) + markdown-specific options.
local M = {}

function M.setup()
  local colors = require("tokyonight.colors").setup()
  vim.api.nvim_set_hl(0, "RMdH1", { fg = colors.red, bg = "" })
  vim.api.nvim_set_hl(0, "RMdH2", { fg = colors.yellow, bg = "" })
  vim.api.nvim_set_hl(0, "RMdH3", { fg = colors.green, bg = "" })
  vim.api.nvim_set_hl(0, "RMdH4", { fg = colors.blue1, bg = "" })
  vim.api.nvim_set_hl(0, "RMdH5", { fg = colors.teal, bg = "" })
  vim.api.nvim_set_hl(0, "RMdH6", { fg = colors.purple, bg = "" })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.opt_local.lbr = true
    end,
  })
end

return M
