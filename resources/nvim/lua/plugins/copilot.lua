return {
	"github/copilot.vim",
  event = "VeryLazy",
	config = function()
		vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")

		vim.cmd("Copilot disable")
		vim.g.copilot_enabled = false

		vim.api.nvim_create_user_command("CopilotToggle", function()
			if vim.g.copilot_enabled then
				vim.cmd("Copilot disable")
				vim.g.copilot_enabled = false
				vim.notify("Copilot OFF")
			else
				vim.cmd("Copilot enable")
				vim.g.copilot_enabled = true
				vim.notify("Copilot ON")
			end
		end, { nargs = 0 })

		vim.keymap.set( "", "<leader>ct", ":CopilotToggle<CR>",
			{ noremap = true, silent = true, desc = "Toggle Copilot" }
		)
	end,
}
