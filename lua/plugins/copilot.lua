-- lua/plugins/copilot.lua
-- GitHub Copilot integration

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = true,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<Tab>",
						accept_word = false,
						accept_line = "<C-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = true,
					markdown = true,
					help = false,
					gitcommit = true,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
					solidity = true,
					rust = true,
					python = true,
					-- Enable for all filetypes
					["*"] = true,
				},
				-- Features for nvim-cmp integration
				copilot_node_command = "node",
				server_opts_overrides = {},
			})

			-- Add Copilot status and toggle commands
			vim.api.nvim_create_user_command("CopilotStatus", function()
				local status = require("copilot.api").status.data
				vim.notify("Copilot: " .. status.message, vim.log.levels.INFO)
			end, {})

			vim.api.nvim_create_user_command("CopilotToggle", function()
				local suggestion = require("copilot.suggestion")
				local enabled = suggestion.is_auto_triggered()
				if enabled then
					suggestion.toggle_auto_trigger()
					vim.notify("Copilot auto-trigger disabled", vim.log.levels.INFO)
				else
					suggestion.toggle_auto_trigger()
					vim.notify("Copilot auto-trigger enabled", vim.log.levels.INFO)
				end
			end, {})

			-- Setup keymaps for Copilot
			vim.keymap.set("n", "<leader>cpt", "<cmd>CopilotToggle<CR>", { desc = "Toggle Copilot" })
			vim.keymap.set("n", "<leader>cps", "<cmd>CopilotStatus<CR>", { desc = "Copilot status" })
			vim.keymap.set("n", "<leader>cpp", "<cmd>Copilot panel<CR>", { desc = "Copilot panel" })

			-- Add manual trigger for suggestions
			vim.keymap.set("i", "<C-\\>", function()
				require("copilot.suggestion").trigger()
			end, { desc = "Trigger Copilot suggestion" })
		end,
	},
}
