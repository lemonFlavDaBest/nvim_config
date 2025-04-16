-- init.lua
-- Main initialization file for Neovim configuration

-- Setup global variables
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = "," -- Set local leader key to comma

-- Load core components
require("lua.core.options") -- General Neovim options
require("lua.core.keymaps") -- Key mappings
require("lua.core.plugins") -- Plugin management
require("lua.core.ui") -- UI configuration

-- Set up autocommands
local augroup = vim.api.nvim_create_augroup("custom_augroup", { clear = true })

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto-format on save with conform.nvim
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function()
		local conform = require("conform")
		conform.format({ async = false, lsp_fallback = true })
	end,
})

-- Load LSP configuration
-- require("lsp.setup")
vim.api.nvim_create_autocmd("VeryLazy", {
  callback = function()
    require("lsp.setup")
  end,
  once = true,
})
-- Set termguicolors only if supported
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
end

-- Optimize specifically for Ghostty terminal
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		local term = os.getenv("TERM")
		local terminfo = vim.fn.system("infocmp -x | grep -o 'TERM=[^,]*'")

		if string.find(term or "", "ghostty") or string.find(terminfo or "", "ghostty") then
			-- Ghostty-specific settings
			vim.g.ghostty_terminal = true

			-- Set proper cursor shapes
			vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

			-- Set up undercurl if terminal supports it
			vim.cmd([[let &t_Cs = "\e[4:3m"]])
			vim.cmd([[let &t_Ce = "\e[4:0m"]])
		end
	end,
	once = true,
})

-- Initialize colorscheme
-- vim.cmd("colorscheme catppuccin")
-- With this safer version:
-- colorscheme catppuccin
vim.cmd.colorscheme("catppuccin")
