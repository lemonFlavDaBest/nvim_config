Vim�UnDo� A	��V�P�e�����,y�m ��ߦu�q2,�  C       b                           g�&^   	 _�                    r        ����                                                                                                                                                                                                                                                                                                                            r           r           V        g�m     �   q   s  0    �   r   s  0    �   q   r          -    "tsserver",      -- TypeScript/JavaScript5��    q                      /      .               �    q                      /                     5�_�                    r        ����                                                                                                                                                                                                                                                                                                                            r           r          V        g�t    �        5      .  -- Enable completion triggered by <c-x><c-o>   J  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')�        R      +  -- Setup buffer-local keymaps and options   @  local opts = { noremap = true, silent = true, buffer = bufnr }          -- Keymapping helper   1  local keymap = function(mode, keys, func, desc)       if desc then         desc = 'LSP: ' .. desc       end   d    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })     end          -- Keymaps   A  keymap('n', 'gD', vim.lsp.buf.declaration, "Go to declaration")   ?  keymap('n', 'gd', vim.lsp.buf.definition, "Go to definition")   <  keymap('n', 'K', vim.lsp.buf.hover, "Hover documentation")   G  keymap('n', 'gi', vim.lsp.buf.implementation, "Go to implementation")   D  keymap('n', '<C-k>', vim.lsp.buf.signature_help, "Signature help")   U  keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, "Add workspace folder")   [  keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")   ~  keymap('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders")   J  keymap('n', '<leader>D', vim.lsp.buf.type_definition, "Type definition")   9  keymap('n', '<leader>rn', vim.lsp.buf.rename, "Rename")   C  keymap('n', '<leader>ca', vim.lsp.buf.code_action, "Code action")   >  keymap('n', 'gr', vim.lsp.buf.references, "Show references")   ]  keymap('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, "Format code")          -- Diagnostics   D  keymap('n', '[d', vim.diagnostic.goto_prev, "Previous diagnostic")   @  keymap('n', ']d', vim.diagnostic.goto_next, "Next diagnostic")   I  keymap('n', '<leader>e', vim.diagnostic.open_float, "Show diagnostics")   Z  keymap('n', '<leader>q', vim.diagnostic.setloclist, "Show diagnostics in location list")�   +   3  Y      8  -- Set autocommands conditional on server capabilities   >  if client.server_capabilities.documentHighlightProvider then   Y    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })   /    vim.api.nvim_create_autocmd("CursorHold", {   0      callback = vim.lsp.buf.document_highlight,         buffer = bufnr,         group = group,       })   0    vim.api.nvim_create_autocmd("CursorMoved", {   .      callback = vim.lsp.buf.clear_references,         buffer = bufnr,         group = group,       })     end�   :   M  L      0  -- Auto-format on save if supported by the LSP   ?  if client.server_capabilities.documentFormattingProvider then   4    -- We'll use conform.nvim instead for formatting   H    -- This is handled in the main init.lua with BufWritePre autocommand     end�   @   a  1      M  -- Disable formatting for certain LSP servers if we want to use other tools   >  if client.name == "tsserver" or client.name == "lua_ls" then   A    client.server_capabilities.documentFormattingProvider = false   F    client.server_capabilities.documentRangeFormattingProvider = false     end�   K   Q  1        properties = {       'documentation',       'detail',       'additionalTextEdits',     }�   R   U  1        dynamicRegistration = false,     lineFoldingOnly = true�   W   Z  1      &if pcall(require, 'cmp_nvim_lsp') then   K  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)�   _   j  1   
     ui = {       border = "rounded",       icons = {          package_installed = "✓",         package_pending = "➜",   !      package_uninstalled = "✗"       }     },   "  log_level = vim.log.levels.INFO,      max_concurrent_installers = 4,�   m   {  1        ensure_installed = {       "lua_ls",        -- Lua       "rust_analyzer", -- Rust       "pyright",       -- Python   "typescript-language-server",        "solidity",      -- Solidity       "cssls",         -- CSS       "html",          -- HTML       "jsonls",        -- JSON       "bashls",        -- Bash        "marksman",      -- Markdown     },      automatic_installation = true,�   �   �  1        -- Default setup handler     function(server_name)       local opts = {         on_attach = M.on_attach,   $      capabilities = M.capabilities,       }�   �   �  1      .    -- Check for server-specific configuration   Y    local has_custom_config, custom_config = pcall(require, "lsp.config." .. server_name)       if has_custom_config then   >      opts = vim.tbl_deep_extend("force", opts, custom_config)       end�   �   �  1   _       -- Setup the LSP server   &    lspconfig[server_name].setup(opts)     end,        *  -- Special handlers for specific servers     ["lua_ls"] = function()       lspconfig.lua_ls.setup({         on_attach = M.on_attach,   $      capabilities = M.capabilities,         settings = {           Lua = {             diagnostics = {               globals = { "vim" }             },             workspace = {               library = {   8              [vim.fn.expand("$VIMRUNTIME/lua")] = true,   :              [vim.fn.stdpath("config") .. "/lua"] = true,               },   $            checkThirdParty = false,             },             telemetry = {               enable = false,             },             completion = {   $            callSnippet = "Replace",             },   
        },         },       })     end,           ["rust_analyzer"] = function()   0    -- Use rust-tools for enhanced functionality       local rt_opts = {         server = {            on_attach = M.on_attach,   &        capabilities = M.capabilities,           settings = {             ["rust-analyzer"] = {               checkOnSave = {   !              command = "clippy",               },               cargo = {   !              allFeatures = true,               },               procMacro = {                 enable = true,               },             },   
        },         },         tools = {           inlay_hints = {             auto = true,   &          show_parameter_hints = true,   
        },         },       }          (    require("rust-tools").setup(rt_opts)     end,          ["pyright"] = function()       lspconfig.pyright.setup({         on_attach = M.on_attach,   $      capabilities = M.capabilities,         settings = {           python = {             analysis = {   #            autoSearchPaths = true,   )            diagnosticMode = "workspace",   *            useLibraryCodeForTypes = true,   '            typeCheckingMode = "basic",             },   
        },         },       })          !    -- Also set up DAP for Python       pcall(function()   +      require("dap-python").setup("python")       end)     end,          ["solidity"] = function()       lspconfig.solidity.setup({         on_attach = M.on_attach,   $      capabilities = M.capabilities,   F      cmd = { "nomicfoundation-solidity-language-server", "--stdio" },   !      filetypes = { "solidity" },   2      root_dir = lspconfig.util.find_git_ancestor,   !      single_file_support = true,       })     end,�   �  
  1      0  local formatting = null_ls.builtins.formatting   2  local diagnostics = null_ls.builtins.diagnostics   4  local code_actions = null_ls.builtins.code_actions          null_ls.setup({       debug = false,       sources = {         -- Formatters          formatting.prettier.with({   %        extra_filetypes = { "toml" },   M        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },   	      }),   ;      formatting.black.with({ extra_args = { "--fast" } }),         formatting.stylua,                  -- Linters         diagnostics.flake8,         diagnostics.eslint,                  -- Code actions         code_actions.gitsigns,       },     })�    #  1        conform.setup({       formatters_by_ft = {         lua = { "stylua" },   $      python = { "isort", "black" },   "      javascript = { "prettier" },   "      typescript = { "prettier" },   '      javascriptreact = { "prettier" },   '      typescriptreact = { "prettier" },         json = { "prettier" },         html = { "prettier" },         css = { "prettier" },          markdown = { "prettier" },         rust = { "rustfmt" },   -      solidity = { "forge fmt", "prettier" },       },       format_on_save = {         timeout_ms = 500,         lsp_fallback = true,       },     })�  &  /  1        library = {       enabled = true,       runtime = true,       types = true,       plugins = true,     },     setup_jsonls = true,     lspconfig = true,5��    &                  "      z       n       �                      �            �      �    �                   �      h      )      �    �       ^      ^      <      �            �    �                   M      �       �       �    �                   �      �       �       �    m                   �      I             �    _       	      	      �      �       �       �    W         '      &   �      <       ;       �    R                   n      7       6       �    K                   �      R       K       �    @                   �
                  �    :                   �	      �       �      �    +                   �      �      �       �              Z      ?   P      �      j       �              I      H   �       x       v       5�_�                    v       ����                                                                                                                                                                                                                                                                                                                                                             g�    �   u   w  5      		"typescript-language-server",5��    u                     �                     �    u   .                  �                     �    u   -                  �                     5�_�                    v       ����                                                                                                                                                                                                                                                                                                                                                             g�	�     �   u   v          -		"typescript-language-server", -- Typescript5��    u                      �      .               5�_�      	              {       ����                                                                                                                                                                                                                                                                                                                                                             g�
      �   {   }  5          �   {   }  4    5��    {                      2                     �    {                     6                     �    {                     6                     5�_�      
           	   |       ����                                                                                                                                                                                                                                                                                                                                                             g�
     �   |   ~  5    �   |   }  5    5��    |                      7              .       5�_�   	              
   |       ����                                                                                                                                                                                                                                                                                                                                                             g�
    �   {   |              5��    {                      2                     5�_�   
                 |       ����                                                                                                                                                                                                                                                                                                                                                             g�
    �   {   |          -		"typescript-language-server", -- Typescript5��    {                      2      .               5�_�                   a        ����                                                                                                                                                                                                                                                                                                                                                             g�\2     �   `   f  4       �   a   b  4    5��    `                                   �       5�_�                    `        ����                                                                                                                                                                                                                                                                                                                                                             g�\6    �   `   b  9       �   `   b  8    5��    `                                           �    `                                           �    `                                           5�_�                    b        ����                                                                                                                                                                                                                                                                                                                            b           s          v       g�%    �   a   z  '       �   b   c  '    �   a   c  9      0local has_mason, mason = pcall(require, "mason")   if not has_mason then   U  vim.notify("Mason plugin not loaded yet. LSP setup may fail.", vim.log.levels.WARN)   (  return -- Exit early to prevent errors   end   -- Setup mason first   require("mason").setup({   	ui = {   		border = "rounded",   		icons = {   			package_installed = "✓",   			package_pending = "➜",   			package_uninstalled = "✗",   		},   	},   !	log_level = vim.log.levels.INFO,   	max_concurrent_installers = 4,   })    5��    a                            �              �    a                                   Q      5�_�                     b        ����                                                                                                                                                                                                                                                                                                                            b           m          v       g�&]   	 �   a   t  2       �   b   c  2    �   a   c  >      0local has_mason, mason = pcall(require, "mason")   if not has_mason then   U  vim.notify("Mason plugin not loaded yet. LSP setup may fail.", vim.log.levels.WARN)     -- Try loading Mason via Lazy   !  vim.cmd("Lazy load mason.nvim")     -- Check again   ,  has_mason, mason = pcall(require, "mason")     if not has_mason then   8    -- Still not available, exit early to prevent errors   
    return     end   end    5��    a                            �              �    a                                   r      5�_�                    |       ����                                                                                                                                                                                                                                                                                                                                                             g�
     �   |   }  4       5��    |                      6                     �    |                      6                     5�_�                    r   ,    ����                                                                                                                                                                                                                                                                                                                            r   -       r          V       g�_     �   r   s  1       5��    r                      ]                     �    r                      ]                     5�_�                    r   ,    ����                                                                                                                                                                                                                                                                                                                            s   -       s          V       g�Z     �   q   r  1          �   q   s  2          5��    q                      /                     �    q                     3                     �    q                     3                     5�_�                     r   ,    ����                                                                                                                                                                                                                                                                                                                            s   -       s          V       g�U     �   q   r  1          �   q   s  2          u5��    q                      /                     �    q                     3                     5��