return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")

			treesitter.setup({
				auto_install = true,

				ensure_installed = {
					"bash",
					"html",
					"css",
					"json",
					"lua",
					"php",
					"markdown",
				},

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = false },
			})
		end,
	},
}
