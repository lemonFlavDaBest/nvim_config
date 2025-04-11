-- lua/plugins/which-key.lua
-- Key binding display and management

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local which_key = require("which-key")

			-- Setup configuration
			which_key.setup({
				plugins = {
					marks = true, -- Shows a list of your marks on ' and `
					registers = true, -- Shows your registers on " in NORMAL or <C-r> in INSERT mode
					spelling = {
						enabled = true, -- Enabling this will show WhichKey when pressing z= to select spelling suggestions
						suggestions = 20, -- How many suggestions should be shown in the list?
					},
					-- The presets plugin adds help for a bunch of default keybindings in Neovim
					presets = {
						operators = true, -- adds help for operators like d, y, ...
						motions = true, -- adds help for motions
						text_objects = true, -- help for text objects triggered after entering an operator
						windows = true, -- default bindings on <c-w>
						nav = true, -- misc bindings to work with windows
						z = true, -- bindings for folds, spelling and others prefixed with z
						g = true, -- bindings for prefixed with g
					},
				},
				-- Add operators that will trigger motion and text object completion
				operators = { gc = "Comments" },
				key_labels = {
					-- Override the label used to display some keys
					["<space>"] = "SPC",
					["<cr>"] = "RET",
					["<tab>"] = "TAB",
				},
				motions = {
					count = true,
				},
				icons = {
					breadcrumb = "»", -- Symbol used in the command line area that shows your active key combo
					separator = "➜", -- Symbol used between a key and its label
					group = "+", -- Symbol prepended to a group
				},
				popup_mappings = {
					scroll_down = "<c-d>", -- Binding to scroll down inside the popup
					scroll_up = "<c-u>", -- Binding to scroll up inside the popup
				},
				window = {
					border = "rounded", -- None, Single, Double, Shadow, Rounded
					position = "bottom", -- Bottom, Top
					margin = { 1, 0, 1, 0 }, -- Extra window margin [top, right, bottom, left]
					padding = { 2, 2, 2, 2 }, -- Extra window padding [top, right, bottom, left]
					winblend = 0, -- Transparency of the window (0-100)
				},
				layout = {
					height = { min = 4, max = 25 }, -- Min and max height of the columns
					width = { min = 20, max = 50 }, -- Min and max width of the columns
					spacing = 3, -- Spacing between columns
					align = "left", -- Align columns left, center or right
				},
				ignore_missing = false, -- Hide mappings for which we don't have a label
				hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- Hide mapping hints
				show_help = true, -- Show a help message in the command line for using WhichKey
				show_keys = true, -- Show the currently pressed key and its label as a message in the command line
				triggers = "auto", -- Automatically setup triggers
				-- triggers = {"<leader>"}, -- Only use these specific trigger keys
				triggers_nowait = {
					-- Marks
					"`",
					"'",
					"g`",
					"g'",
					-- Registers
					'"',
					"<c-r>",
					-- Spelling
					"z=",
				},
				triggers_blacklist = {
					-- List of mode / prefixes that should never be hooked by WhichKey
					i = { "j", "k" },
					v = { "j", "k" },
				},
				-- disable the WhichKey popup for certain buffers and file types
				disable = {
					buftypes = {},
					filetypes = { "TelescopePrompt" },
				},
			})

			-- Register all keymaps with categories
			which_key.register({
				["<leader>"] = {
					-- File menu
					f = {
						name = "File",
						f = { "Find file" },
						g = { "Live grep" },
						r = { "Recent files" },
						n = { "New file" },
						e = { "File browser" },
						w = { "Find word" },
					},

					-- Buffer controls
					b = {
						name = "Buffer",
						d = { "Delete buffer" },
						n = { "Next buffer" },
						p = { "Previous buffer" },
						o = { "Other buffer" },
						s = { "Save buffer" },
						c = { "Pick buffer" },
						r = { "Delete buffers to the right" },
						l = { "Delete buffers to the left" },
					},

					-- Window management
					w = {
						name = "Window",
						s = { "Split window" },
						v = { "Vertical split" },
						c = { "Close window" },
						o = { "Close other windows" },
						h = { "Move to left window" },
						j = { "Move to bottom window" },
						k = { "Move to top window" },
						l = { "Move to right window" },
						["="] = { "Balance windows" },
					},

					-- Terminal options
					t = {
						name = "Terminal",
						t = { "Toggle terminal" },
						f = { "Floating terminal" },
						v = { "Vertical terminal" },
						h = { "Horizontal terminal" },
						g = { "Lazygit terminal" },
						p = { "Python terminal" },
						r = { "Rust terminal" },
						s = { "Solidity terminal" },
					},

					-- LSP functions
					l = {
						name = "LSP",
						i = { "LSP info" },
						r = { "Rename" },
						s = { "Document symbols" },
						S = { "Workspace symbols" },
						d = { "Definition" },
						D = { "Declaration" },
						t = { "Type definition" },
						I = { "Implementation" },
						f = { "Format document" },
						a = { "Code action" },
						h = { "Hover documentation" },
						o = { "Organize imports" },
						n = { "Reame" },
					},

					-- Git commands
					g = {
						name = "Git",
						g = { "Lazygit" },
						j = { "Next hunk" },
						k = { "Previous hunk" },
						s = { "Stage hunk" },
						u = { "Undo stage hunk" },
						p = { "Preview hunk" },
						b = { "Blame line" },
						d = { "Diff file" },
						c = { "Commits" },
						C = { "Commit file" },
						P = { "Push" },
					},

					-- Diagnostics
					d = {
						name = "Diagnostics",
						d = { "List diagnostics" },
						n = { "Next diagnostic" },
						p = { "Previous diagnostic" },
						f = { "First diagnostic" },
						l = { "Last diagnostic" },
						a = { "All diagnostics" },
					},

					-- Search commands
					s = {
						name = "Search",
						b = { "Buffers" },
						c = { "Commands" },
						h = { "Help" },
						m = { "Marks" },
						r = { "Registers" },
						t = { "TODOs" },
						k = { "Keymaps" },
					},

					-- Harpoon marks
					h = {
						name = "Harpoon",
						a = { "Add file" },
						m = { "Menu" },
						["1"] = { "File 1" },
						["2"] = { "File 2" },
						["3"] = { "File 3" },
						["4"] = { "File 4" },
						n = { "Next mark" },
						p = { "Prev mark" },
					},

					-- Debugging
					c = {
						name = "Code/Debug",
						b = { "Toggle breakpoint" },
						c = { "Continue" },
						i = { "Step into" },
						o = { "Step over" },
						O = { "Step out" },
						r = { "Restart" },
						e = { "Evaluate" },
						t = { "Terminate" },
						u = { "Toggle UI" },
					},

					-- Project management
					p = {
						name = "Project",
						f = { "Find file" },
						p = { "Open project" },
						s = { "Save session" },
						l = { "Load session" },
					},

					-- Quit options
					q = { "Quit" },
					Q = { "Quit all" },

					-- Toggle options
					o = {
						name = "Toggle Options",
						n = { "Line numbers" },
						r = { "Relative numbers" },
						t = { "Tab indentation" },
						s = { "Spell check" },
						w = { "Word wrap" },
						h = { "Search highlight" },
						c = { "Cursor line" },
						l = { "List chars" },
					},
				},
				["<leader>x"] = {
					name = "Diagnostics/Trouble",
					x = { "Document diagnostics" },
					X = { "Workspace diagnostics" },
					l = { "Location list" },
					q = { "Quickfix list" },
					r = { "LSP references" },
					d = { "LSP definitions" },
					i = { "LSP implementations" },
					t = { "LSP type definitions" },
				},

				-- Add illuminate.nvim keymappings in which-key
				["[r"] = { "Previous reference" },
				["]r"] = { "Next reference" },
				["[["] = { "Previous reference" },
				["]]"] = { "Next reference" },

				-- Add UI toggle section if not already existing
				["<leader>u"] = {
					name = "UI",
					i = { "Toggle word illumination" },
				},
				-- Navigating buffers
				["]"] = {
					b = "Next buffer",
					d = "Next diagnostic",
					h = "Next hunk",
				},
				["["] = {
					b = "Previous buffer",
					d = "Previous diagnostic",
					h = "Previous hunk",
				},

				-- g commands
				g = {
					d = "Go to definition",
					D = "Go to declaration",
					i = "Go to implementation",
					r = "Go to references",
					t = "Go to type definition",
					s = "Go to signature help",
				},
			})
		end,
	},
}
