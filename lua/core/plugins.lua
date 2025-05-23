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

	-- LSP-related plugins (updated section)
	-- Neodev - needs to be setup before lspconfig
	{
		"folke/neodev.nvim",
		lazy = false,
		priority = 100,
		config = function()
			require("neodev").setup({
				library = {
					enabled = true,
					runtime = true,
					types = true,
					plugins = true,
				},
				setup_jsonls = true,
				lspconfig = true,
			})
		end,
	},

	-- Mason package manager for LSP
	{
		"williamboman/mason.nvim",
		lazy = false,
		priority = 90,
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

	-- Mason-LSPConfig bridge
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		priority = 80,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", 
					"rust_analyzer", 
					"pyright", 
					"solidity",
					"cssls", 
					"html", 
					"jsonls", 
					"bashls", 
					"marksman",
				},
				automatic_installation = true,
			})
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format current buffer",
			},
		},
		priority = 70,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					markdown = { "prettier" },
					rust = { "rustfmt" },
					solidity = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		priority = 60,
		config = function()
			require("lsp.setup")
		end,
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
