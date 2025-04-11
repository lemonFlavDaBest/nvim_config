-- lua/plugins/illuminate.lua
-- Automatically highlighting other uses of the word under the cursor

return {
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			-- Delay in milliseconds
			delay = 200,

			-- Don't highlight word under cursor (done by LSP)
			under_cursor = false,

			-- Filetypes to disable illuminate for
			filetypes_denylist = {
				"dirvish",
				"fugitive",
				"alpha",
				"NvimTree",
				"lazy",
				"norg",
				"toggleterm",
				"TelescopePrompt",
				"DressingInput",
				"neo-tree",
			},

			-- Modes to not illuminate in
			modes_denylist = { "v", "vs", "V", "Vs", "\x16", "\x16s", "i" },

			-- Filetypes to illuminate in all modes
			filetypes_allowlist = {},

			-- Default providers (LSP, Treesitter, Regex)
			providers = {
				"lsp",
				"treesitter",
				"regex",
			},

			-- Regex for specific filetypes, used if LSP and Treesitter are unavailable
			large_file_overrides = {
				large_file_cutoff = 2000, -- lines
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			-- Set highlight style for illuminated words
			vim.api.nvim_command("hi def link IlluminatedWordText Visual")
			vim.api.nvim_command("hi def link IlluminatedWordRead Visual")
			vim.api.nvim_command("hi def link IlluminatedWordWrite Visual")

			-- Set keymaps for navigating between illuminated words
			vim.keymap.set("n", "]]", function()
				require("illuminate").goto_next_reference()
			end, { desc = "Next reference" })

			vim.keymap.set("n", "[[", function()
				require("illuminate").goto_prev_reference()
			end, { desc = "Previous reference" })

			-- Additional motions using vim-illuminate
			vim.keymap.set("n", "]r", function()
				require("illuminate").goto_next_reference(false)
			end, { desc = "Next reference" })

			vim.keymap.set("n", "[r", function()
				require("illuminate").goto_prev_reference(false)
			end, { desc = "Previous reference" })

			-- Set up autocommand to disable illumination on large files
			local illuminate_augroup = vim.api.nvim_create_augroup("illuminate_augroup", { clear = true })

			vim.api.nvim_create_autocmd("BufEnter", {
				group = illuminate_augroup,
				callback = function()
					local line_count = vim.api.nvim_buf_line_count(0)
					if line_count > opts.large_file_overrides.large_file_cutoff then
						vim.cmd("IlluminatePauseBuf")
					end
				end,
			})

			-- Toggle illumination
			vim.api.nvim_create_user_command("IlluminationToggle", function()
				local buf = vim.api.nvim_get_current_buf()
				local is_paused = vim.b[buf].illuminate_paused

				if is_paused then
					vim.cmd("IlluminateResumeBuf")
					vim.notify("Illumination resumed", vim.log.levels.INFO)
				else
					vim.cmd("IlluminatePauseBuf")
					vim.notify("Illumination paused", vim.log.levels.INFO)
				end
			end, {})

			-- Add keybinding to toggle illumination
			vim.keymap.set("n", "<leader>ui", "<cmd>IlluminationToggle<CR>", { desc = "Toggle word illumination" })
		end,
	},
}
