-- OBACHT: had to install treesitter-cli with `cargo install tree-sitter-cli`
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			ts.install({
				"bash",
				"html",
				"css",
				"json",
				"lua",
				"php",
				"markdown",
				"typst",
				"rust",
				"python",
				"java",
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local buftype = vim.bo[args.buf].buftype
					local filetype = vim.bo[args.buf].filetype

					-- skip special buffers and filetypes without parsers
					if buftype ~= "" then
						return
					end

					-- skip snacks startpage
					if filetype:match("^snacks_") then
						return
					end

					-- only start if a parser exists
					local lang = vim.treesitter.language.get_lang(filetype)
					if lang and pcall(vim.treesitter.language.add, lang) then
						vim.treesitter.start()
					end
				end,
			})
		end,
	},
}
