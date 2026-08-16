-- Laravel.nvim setup, only loaded when an `artisan` file is present.
local M = {}

local function laravel_cond()
  return vim.fn.filereadable("artisan") == 1
end

local function setup_laravel()
  require("laravel").setup({
    lsp_server = "phpactor",
    features = {
      pickers = {
        provider = "snacks",
      },
    },
  })

  local opts = { desc = "Laravel" }
  vim.keymap.set("n", "<leader>ll", function() Laravel.pickers.laravel() end, vim.tbl_extend("keep", { desc = "Laravel: Open Laravel Picker" }, opts))
  vim.keymap.set("n", "<c-g>", function() Laravel.commands.run("view:finder") end, vim.tbl_extend("keep", { desc = "Laravel: Open View Finder" }, opts))
  vim.keymap.set("n", "<leader>la", function() Laravel.pickers.artisan() end, vim.tbl_extend("keep", { desc = "Laravel: Open Artisan Picker" }, opts))
  vim.keymap.set("n", "<leader>lt", function() Laravel.commands.run("actions") end, vim.tbl_extend("keep", { desc = "Laravel: Open Actions Picker" }, opts))
  vim.keymap.set("n", "<leader>lr", function() Laravel.pickers.routes() end, vim.tbl_extend("keep", { desc = "Laravel: Open Routes Picker" }, opts))
  vim.keymap.set("n", "<leader>lh", function() Laravel.run("artisan docs") end, vim.tbl_extend("keep", { desc = "Laravel: Open Documentation" }, opts))
  vim.keymap.set("n", "<leader>lm", function() Laravel.pickers.make() end, vim.tbl_extend("keep", { desc = "Laravel: Open Make Picker" }, opts))
  vim.keymap.set("n", "<leader>lc", function() Laravel.pickers.commands() end, vim.tbl_extend("keep", { desc = "Laravel: Open Commands Picker" }, opts))
  vim.keymap.set("n", "<leader>lo", function() Laravel.pickers.resources() end, vim.tbl_extend("keep", { desc = "Laravel: Open Resources Picker" }, opts))
  vim.keymap.set("n", "<leader>lp", function() Laravel.commands.run("command_center") end, vim.tbl_extend("keep", { desc = "Laravel: Open Command Center" }, opts))
  vim.keymap.set("n", "gf", function()
    local ok, res = pcall(function()
      if Laravel.app("gf").cursorOnResource() then
        return "<cmd>lua Laravel.commands.run('gf')<cr>"
      end
    end)
    if not ok or not res then
      return "gf"
    end
    return res
  end, { expr = true, noremap = true, desc = "Laravel: Open Related File" })
end

function M.setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      if laravel_cond() then
        setup_laravel()
      end
    end,
  })
end

return M
