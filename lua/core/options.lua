-- lua/core/options.lua
-- General Neovim options and settings

local opt = vim.opt

-- Line numbers
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Show relative line numbers

-- Tabs & Indentation
opt.tabstop = 2             -- Number of spaces tabs count for
opt.softtabstop = 2         -- Number of spaces when editing
opt.shiftwidth = 2          -- Size of an indent
opt.expandtab = true        -- Use spaces instead of tabs
opt.smartindent = true      -- Insert indents automatically
opt.autoindent = true       -- Copy indent from current line when starting new one

-- Line wrapping
opt.wrap = false            -- Disable line wrapping

-- Search settings
opt.ignorecase = true       -- Ignore case when searching
opt.smartcase = true        -- Unless you type a capital
opt.incsearch = true        -- Show matches as you type
opt.hlsearch = true         -- Highlight matches

-- Cursor line
opt.cursorline = true       -- Highlight the current line

-- Appearance
opt.termguicolors = true    -- True color support
opt.background = "dark"     -- Use dark mode
opt.signcolumn = "yes"      -- Always show signcolumn
opt.cmdheight = 1           -- Height of command line
opt.pumheight = 10          -- Maximum number of items to show in popup menu

-- Backspace
opt.backspace = "indent,eol,start"  -- Make backspace work as expected

-- Clipboard
opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Split windows
opt.splitright = true       -- Split windows to the right
opt.splitbelow = true       -- Split windows below

-- Update time
opt.updatetime = 100        -- Faster completion
opt.timeoutlen = 400        -- Faster keycode recognition

-- Scrolling
opt.scrolloff = 8           -- Lines of context above/below cursor
opt.sidescrolloff = 8       -- Columns of context to the left/right

-- File handling
opt.swapfile = false        -- Don't use swapfile
opt.backup = false          -- Don't create backups
opt.undofile = true         -- Use persistent undo
opt.undodir = vim.fn.expand("~/.config/nvim/undodir")  -- Undo directory

-- Completion
opt.completeopt = {"menu", "menuone", "noselect"}  -- Better completion experience

-- Enable mouse
opt.mouse = "a"             -- Enable mouse in all modes

-- Wild menu
opt.wildmenu = true         -- Command-line completion
opt.wildmode = "longest:full,full"  -- Command-line completion mode

-- Don't show certain types of files in netrw
vim.g.netrw_list_hide = "^./$,^../$"

-- Better display
opt.list = true             -- Show some invisible characters
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹"
}

-- Global statusline
opt.laststatus = 3          -- Use global statusline

-- Filetype-specific settings
-- These file types will be detected and configured through ftplugin

-- Create the undodir if it doesn't exist
do
  local undodir = vim.fn.expand(opt.undodir:get()[1])
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
  end
end
