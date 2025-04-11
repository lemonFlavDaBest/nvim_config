-- lua/lsp/config/solidity.lua
-- Solidity LSP configuration

-- Simple configuration that works with both manual installation and Mason
return {
	-- Use Mason's path if available, otherwise try PATH
	cmd = function()
		local mason_registry = require("mason-registry")
		if mason_registry.is_installed("solidity-ls") then
			local package = mason_registry.get_package("solidity-ls")
			local path = package:get_install_path() .. "/node_modules/.bin/nomicfoundation-solidity-language-server"
			return { path, "--stdio" }
		else
			return { "nomicfoundation-solidity-language-server", "--stdio" }
		end
	end,

	-- Only apply to .sol files
	filetypes = { "solidity" },

	-- Find the root directory (usually a Git repository)
	root_dir = require("lspconfig.util").find_git_ancestor,

	-- Allow working with a single file even outside of a project
	single_file_support = true,

	-- Settings for the server
	settings = {
		solidity = {
			-- Package settings
			packageDefaultDependenciesContractName = "",
			packageDefaultDependenciesDirectory = "node_modules",

			-- Validation settings
			validationDelay = 1500,
			enabledAsYouTypeCompilationErrorCheck = true,

			-- Compilation settings
			compileUsingRemoteVersion = "latest",

			-- Linting settings (removed problematic JSON-like syntax)
			linting = {
				enabled = true,
			},
		},
	},
}
