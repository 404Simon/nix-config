-- Quickfix toggle/navigation and misc utilities (ported from the old init.lua/vim-options.lua).
local M = {}

function M.qf_next()
  pcall(vim.cmd.cnext)
end

function M.qf_prev()
  pcall(vim.cmd.cprev)
end

-- Override the default qf buffer mappings (<C-n> -> :cnewer, <C-p> -> :colder)
function M.setup_qf_maps()
  vim.keymap.set("n", "<C-n>", M.qf_next, { buffer = true, desc = "Next quickfix item" })
  vim.keymap.set("n", "<C-p>", M.qf_prev, { buffer = true, desc = "Previous quickfix item" })
end

function M.toggle_qf()
  local qf_win = vim.fn.getqflist({ winid = 0 }).winid
  if qf_win ~= 0 then
    vim.cmd("cclose")
  elseif #vim.fn.getqflist() > 0 then
    vim.cmd("copen")
  else
    vim.notify("Quickfix list is empty", vim.log.levels.INFO)
  end
end

local function search_and_open_qf(vimgrep_cmd)
  vim.fn.setqflist({})
  pcall(vim.cmd, vimgrep_cmd)
  local qf_list = vim.fn.getqflist()
  if #qf_list > 0 then
    vim.cmd("copen")
    print(string.format("Found %d non-ASCII characters!", #qf_list))
  else
    print("Clean! No rogue non-ASCII characters found.")
  end
end

function M.find_nonascii_current()
  if vim.bo.binary then
    print("Skipping: Current file is binary")
    return
  end
  search_and_open_qf("vimgrep /[^\\x00-\\x7FäöüßÄÖÜ]/ %")
end

function M.find_nonascii_workspace()
  local text_extensions = "{txt,md,json,html,css,js,ts,py,sh,go,rs,lua,yml,yaml,tex,xml}"
  search_and_open_qf(string.format("vimgrep /[^\\x00-\\x7FäöüßÄÖÜ]/ **/*.%s", text_extensions))
end

function M.toggle_bool()
  local word = vim.fn.expand("<cword>")
  local replacements = {
    True = "False",
    False = "True",
    ["true"] = "false",
    ["false"] = "true",
  }
  local new_word = replacements[word]
  if not new_word then
    vim.notify(string.format("Not a boolean: %q", word), vim.log.levels.WARN)
    return
  end
  vim.cmd.normal({ "ciw" .. new_word, bang = true })
end

return M
