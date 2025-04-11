-- lua/plugins/conform.lua
-- Formatting configuration

return {
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
    config = function()
      require("conform").setup({
        -- Define formatters
        formatters_by_ft = {
          -- Lua
          lua = { "stylua" },
          
          -- Web languages
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          
          -- Python
          python = { "isort", "black" },
          
          -- Rust
          rust = { "rustfmt" },
          
          -- Solidity
          solidity = { "prettier" },
          
          -- Shell
          sh = { "shfmt" },
          bash = { "shfmt" },
          
          -- C/C++
          c = { "clang-format" },
          cpp = { "clang-format" },
          
          -- Other
          go = { "gofmt" },
          sql = { "sql-formatter" },
          toml = { "taplo" },
        },
        
        -- Format on save settings
        format_on_save = function(bufnr)
          -- Disable formatting for large files
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > max_filesize then
            return
          end
          
          -- Disable for specified filetypes
          local ignore_filetypes = { "sql", "txt", "text" }
          local filetype = vim.bo[bufnr].filetype
          if vim.tbl_contains(ignore_filetypes, filetype) then
            return
          end
          
          -- Default options
          return {
            timeout_ms = 500,
            lsp_fallback = true,
          }
        end,
        
        -- Automatically detect formatters
        formatters = {
          -- Configure individual formatters
          shfmt = {
            prepend_args = { "-i", "2", "-ci" }, -- 2 space indentation
          },
          black = {
            prepend_args = { "--line-length", "88" },
          },
          isort = {
            prepend_args = { "--profile", "black" },
          },
          prettier = {
            prepend_args = { "--print-width", "100", "--tab-width", "2" },
          },
          stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
          rustfmt = {
            prepend_args = { "--edition", "2021" },
          },
        },
        
        -- Log level
        log_level = vim.log.levels.ERROR,
        
        -- Notify on formatting errors
        notify_on_error = true,
      })
      
      -- Format command
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, 0 },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end,
  },
}
