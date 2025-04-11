-- lua/plugins/mini.lua
-- Collection of minimal, independent, and fast Neovim plugins

return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			-- mini.pairs: Automatically insert paired characters like brackets and quotes
			require("mini.pairs").setup({
				-- Maps to consider for insertion with its left part
				pairs = {
					{ "(", ")" },
					{ "[", "]" },
					{ "{", "}" },
					{ '"', '"' },
					{ "'", "'" },
					{ "`", "`" },
				},
				-- Characters from which to auto-delete right part
				autoclose = true,
				-- Whether to disable mini.pairs in single line comments
				disable_in_comments = false,
				-- Don't add pairs if the next character is alphanumeric
				disable_in_next_char = {
					["'"] = { kind = "balanced", regex = "%w" },
				},
			})

			-- mini.move: Move lines and selections in any direction
			require("mini.move").setup({
				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",

					-- Move current line in Normal mode
					line_left = "<M-h>",
					line_right = "<M-l>",
					line_down = "<M-j>",
					line_up = "<M-k>",
				},
				-- Options which control moving behavior
				options = {
					-- Automatically reindent when moving lines vertically
					reindent_linewise = true,
				},
			})

			-- mini.ai: Enhanced textobjects with various brackets/quotes
			require("mini.ai").setup({
				-- Pairs to match
				custom_textobjects = {
					o = function()
						return require("mini.ai").gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" })
					end,
					f = function()
						return require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" })
					end,
					c = function()
						return require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" })
					end,
				},
				mappings = {
					around = "a",
					inside = "i",
					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",
				},
				-- Search method: 'cover_or_next' - start search from the cursor position
				search_method = "cover_or_next",
			})

			-- mini.comment: Fast code commenting
			require("mini.comment").setup({
				-- Options which control module behavior
				options = {
					-- Whether to ignore blank lines
					ignore_blank_line = true,
					-- Whether to recognize both single and multiline comments
					custom_commentstring = function()
						return vim.bo.commentstring
					end,
				},
				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Toggle comment (like `gcip` - comment inner paragraph) in Normal and Visual modes
					comment = "gc",
					-- Toggle comment on current line in Normal mode
					comment_line = "gcc",
					-- Define 'comment' textobject (like `dgc` - delete whole comment block)
					textobject = "gc",
				},
				-- Hook functions for extending commenting behavior
				hooks = {
					-- Pre-hook called before mapping is executed
					pre = nil,
					-- Post-hook called after mapping is executed
					post = nil,
				},
			})

			-- mini.cursorword: Highlight words matching the one under cursor
			require("mini.cursorword").setup({
				-- Delay (in ms) between cursor movement and highlighting
				delay = 300,
			})

			-- mini.jump: Smarter jump inside any line with f/F/t/T
			require("mini.jump").setup({
				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					forward = "f",
					backward = "F",
					forward_till = "t",
					backward_till = "T",
					repeat_jump = ";",
				},
				-- Delay in milliseconds between jump and highlighting all possible jumps
delay = { highlight = 0 },
				-- Highlight groups for different jumping phases
				highlight = {
					-- Highlight for current target: the word you'll jump to
					current = "MiniJumpCurrent",
					-- Highlight for other targets
					dim = "MiniJumpDim",
				},
			})

			-- mini.surround: Fast surround actions (add, delete, replace, find, highlight)
			-- Not enabling by default since we might use another surround plugin
			-- require("mini.surround").setup({})
		end,
	},
}
