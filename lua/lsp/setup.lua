-- lua/lsp/setup.lua
-- LSP setup and configuration

-- Initialize LSP configuration
local M = {}

-- Set up on_attach function to be run when LSP client attaches to a buffer
M.on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Setup buffer-local keymaps and options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Keymapping helper
	local keymap = function(mode, keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
	end

	-- Keymaps
	keymap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	keymap("n", "gd", vim.lsp.buf.definition, "Go to definition")
	keymap("n", "K", vim.lsp.buf.hover, "Hover documentation")
	keymap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	keymap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
	keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
	keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
	keymap("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "List workspace folders")
	keymap("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
	keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
	keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
	keymap("n", "gr", vim.lsp.buf.references, "Show references")
	keymap("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, "Format code")

	-- Diagnostics
	keymap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
	keymap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
	keymap("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostics")
	keymap("n", "<leader>q", vim.diagnostic.setloclist, "Show diagnostics in location list")

	-- Set autocommands conditional on server capabilities
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = group,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = group,
		})
	end

	-- Auto-format on save if supported by the LSP
	if client.server_capabilities.documentFormattingProvider then
		-- We'll use conform.nvim instead for formatting
		-- This is handled in the main init.lua with BufWritePre autocommand
	end

	-- Disable formatting for certain LSP servers if we want to use other tools
	if client.name == "tsserver" or client.name == "lua_ls" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end

-- Capabilities with nvim-cmp integration
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- Use cmp_nvim_lsp capabilities if available
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end

M.capabilities = capabilities

-- Now we can safely use Mason
mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})
-- Configure mason-lspconfig
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls", -- Lua
		"rust_analyzer", -- Rust
		"pyright", -- Python
		"solidity", -- Solidity
		"cssls", -- CSS
		"html", -- HTML
		"jsonls", -- JSON
		"bashls", -- Bash
		"marksman", -- Markdown
	},
	automatic_installation = true,
})

-- Load server specific configurations
local lspconfig = require("lspconfig")

-- Server setup loop
require("mason-lspconfig").setup_handlers({
	-- Default setup handler
	function(server_name)
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.capabilities,
		}

		-- Check for server-specific configuration
		local has_custom_config, custom_config = pcall(require, "lsp.config." .. server_name)
		if has_custom_config then
			opts = vim.tbl_deep_extend("force", opts, custom_config)
		end

		-- Setup the LSP server
		lspconfig[server_name].setup(opts)
	end,

	-- Special handlers for specific servers
	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			on_attach = M.on_attach,
			capabilities = M.capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
	end,

	["rust_analyzer"] = function()
		-- Use rust-tools for enhanced functionality
		local rt_opts = {
			server = {
				on_attach = M.on_attach,
				capabilities = M.capabilities,
				settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
						cargo = {
							allFeatures = true,
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},
			tools = {
				inlay_hints = {
					auto = true,
					show_parameter_hints = true,
				},
			},
		}

		require("rust-tools").setup(rt_opts)
	end,

	["pyright"] = function()
		lspconfig.pyright.setup({
			on_attach = M.on_attach,
			capabilities = M.capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						typeCheckingMode = "basic",
					},
				},
			},
		})

		-- Also set up DAP for Python
		pcall(function()
			require("dap-python").setup("python")
		end)
	end,

	["solidity"] = function()
		lspconfig.solidity.setup({
			on_attach = M.on_attach,
			capabilities = M.capabilities,
			cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
			filetypes = { "solidity" },
			root_dir = lspconfig.util.find_git_ancestor,
			single_file_support = true,
		})
	end,
})

-- Configure null-ls for linting and formatting
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if null_ls_status_ok then
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions

	null_ls.setup({
		debug = false,
		sources = {
			-- Formatters
			formatting.prettier.with({
				extra_filetypes = { "toml" },
				extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
			}),
			formatting.black.with({ extra_args = { "--fast" } }),
			formatting.stylua,

			-- Linters
			diagnostics.flake8,
			diagnostics.eslint,

			-- Code actions
			code_actions.gitsigns,
		},
	})
end

-- Configure conform.nvim for formatting
local conform_status_ok, conform = pcall(require, "conform")
if conform_status_ok then
	conform.setup({
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
			solidity = { "forge fmt", "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	})
end

-- Setup neodev for Lua development in Neovim
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

return M
