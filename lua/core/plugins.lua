-- lua/core/plugins.lua
-- Plugin management using lazy.nvim

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins= {
	-- Core plugins
	"nvim-lua/plenary.nvim", -- Lua functions library
	"kyazdani42/nvim-web-devicons", -- Icons

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
			{ "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		keys = {
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal float" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal horizontal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal vertical" },
			{ "<F7>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
		},
	},

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find text" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Find recent files" },
		},
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- Notifications and command line
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
	},

	-- Comments
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
	},

	-- Auto-close pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
	},

	-- LSP
 {
  "williamboman/mason.nvim",
  lazy = false,
  priority = 100,
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end,
},

-- Also make sure mason-lspconfig is added
{
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  priority = 90, -- Slightly lower than mason
  dependencies = { "williamboman/mason.nvim" },
},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim", -- Package manager for LSP/DAP/linters
			"williamboman/mason-lspconfig.nvim", -- Integration with lspconfig
			"folke/neodev.nvim", -- Lua LSP settings
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
		},
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer", -- Buffer source
			"hrsh7th/cmp-path", -- Path source
			"hrsh7th/cmp-cmdline", -- Command line source
			"saadparwaiz1/cmp_luasnip", -- Snippet source
			"L3MON4D3/LuaSnip", -- Snippet engine
			"rafamadriz/friendly-snippets", -- Snippet collection
		},
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
	},

	-- Harpoon file navigation
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2", -- Use harpoon2
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
	},

	-- Language support
	{
		"simrat39/rust-tools.nvim", -- Rust support
		ft = "rust",
		dependencies = { "neovim/nvim-lspconfig" },
	},

	-- Python support
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
	},

	-- Solidity support
	{
		"tomlion/vim-solidity",
		ft = "solidity",
	},

	-- Tmux integration
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
	},
	{
		"benmills/vimux",
		keys = {
			{ "<leader>tr", "<cmd>VimuxRunCommand<CR>", desc = "Run tmux command" },
			{ "<leader>tp", "<cmd>VimuxPromptCommand<CR>", desc = "Prompt tmux command" },
			{ "<leader>tl", "<cmd>VimuxRunLastCommand<CR>", desc = "Run last tmux command" },
			{ "<leader>ti", "<cmd>VimuxInspectRunner<CR>", desc = "Inspect tmux runner" },
			{ "<leader>tz", "<cmd>VimuxZoomRunner<CR>", desc = "Zoom tmux runner" },
		},
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- Better UI components
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},

	-- Outline/symbols view
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = {
			{ "<leader>cs", "<cmd>SymbolsOutline<CR>", desc = "Symbols outline" },
		},
	},
}

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    -- Include the plugins defined in this file
    unpack(plugins),
    -- Import plugins from the plugins directory
    { import = "plugins" }
  },
  defaults = {
    lazy = true, -- Default to lazy loading
  },
  install = {
    -- Install missing plugins on startup
    missing = true,
    -- Try to load one of these colorschemes when starting an installation
    colorscheme = { "catppuccin", "habamax" },
  },
  checker = {
    -- Check for plugin updates
    enabled = true,
    notify = false, -- Don't auto notify of updates
    frequency = 3600, -- Check for updates once per hour
  },
  change_detection = {
    -- Check for config changes
    enabled = true,
    notify = false, -- Don't auto notify of config changes
  },
  performance = {
    rtp = {
      -- Disable some built-in Neovim plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    -- UI customizations
    border = "rounded",
  },
})
