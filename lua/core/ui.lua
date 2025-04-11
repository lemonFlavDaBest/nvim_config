-- lua/core/ui.lua
-- UI configuration

-- Set up the UI elements (independent from plugin configurations)
local M = {}

-- Set colorscheme
M.set_colorscheme = function()
	-- Check if catppuccin is available
	local catppuccin_available = pcall(require, "catppuccin")

	if catppuccin_available then
		vim.cmd("colorscheme catppuccin")
	else
		-- Fallback to a default theme that's always available
		vim.cmd("colorscheme habamax")
	end
end

-- Configure diagnostic icons
M.setup_diagnostics = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	-- Configure diagnostic display
	vim.diagnostic.config({
		virtual_text = {
			prefix = "●",
			severity = {
				min = vim.diagnostic.severity.HINT,
			},
		},
		signs = {
			active = signs,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})
end

-- Configure UI elements of built-in features
M.setup_ui = function()
	-- Fold column width
	vim.opt.foldcolumn = "0"

	-- Popup menu transparency
	vim.opt.pumblend = 10

	-- Configure netrw (built-in file explorer)
	vim.g.netrw_banner = 0
	vim.g.netrw_liststyle = 3
	vim.g.netrw_browse_split = 0
	vim.g.netrw_winsize = 25

	-- Configure built-in completion menu
	vim.opt.completeopt = { "menuone", "noselect" }

	-- Make floating windows look nicer
	vim.opt.winblend = 0

	-- Customize fold display
	vim.opt.fillchars = {
		fold = " ",
		-- Fixed: use proper characters for foldopen and foldclose
		foldopen = "▾",
		foldclose = "▸",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	}

	-- Command line height
	vim.opt.cmdheight = 1

	-- Global statusline
	vim.opt.laststatus = 3

	-- Optimize for Ghostty terminal if detected
	if vim.g.ghostty_terminal then
		-- Specific optimizations for ghostty
		vim.opt.termguicolors = true
	end
end

-- Configuration for floating windows
M.float_config = function(title)
	return {
		border = "rounded",
		title = title,
		title_pos = "center",
		max_width = math.floor(vim.o.columns * 0.8),
		max_height = math.floor(vim.o.lines * 0.8),
	}
end

-- Set up everything
M.setup_diagnostics()
M.setup_ui()

-- Only set colorscheme if not being set by a plugin
if not package.loaded["catppuccin"] then
	M.set_colorscheme()
end

return M
