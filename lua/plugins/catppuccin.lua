-- lua/plugins/catppuccin.lua
-- Catppuccin colorscheme configuration

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Load before other start plugins
		lazy = false, -- Make sure to load this during startup
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = {
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- Set to true for transparent background
				term_colors = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = { "italic" },
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = function(colors)
					return {
						-- Enhance Solidity highlighting
						["@type.solidity"] = { fg = colors.yellow },
						["@keyword.solidity"] = { fg = colors.mauve, style = { "italic" } },
						["@function.solidity"] = { fg = colors.blue },
						["@variable.solidity"] = { fg = colors.text },
						["@property.solidity"] = { fg = colors.lavender },
						["@constructor.solidity"] = { fg = colors.red },
						["@constant.solidity"] = { fg = colors.peach },
						["@string.solidity"] = { fg = colors.green },
						["@number.solidity"] = { fg = colors.peach },
						["@operator.solidity"] = { fg = colors.sky },
						["@punctuation.delimiter.solidity"] = { fg = colors.overlay1 },
						["@punctuation.bracket.solidity"] = { fg = colors.overlay2 },
						["@comment.solidity"] = { fg = colors.surface2, style = { "italic" } },
					}
				end,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = true,
					mini = true,
					harpoon = true,
					treesitter = true,
					treesitter_context = true,
					illuminate = {
						enabled = true,
						lsp = true,
					},
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
					-- Integrate with other plugins you use
					dap = {
						enabled = true,
						enable_ui = true,
					},
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					which_key = true,
					noice = true,
					bufferline = true,
					markdown = true,
				},
			})

			-- Set Catppuccin as the default colorscheme
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
