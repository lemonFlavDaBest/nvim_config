-- lua/plugins/gitsigns.lua
-- Git integration in the sign column

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        -- Signs configuration
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        
        -- Sign column and line number highlighting
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        
        -- Watch git files for external changes
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        
        -- Attach to untracked files
        attach_to_untracked = true,
        
        -- Track git files in detached working copies
        git_mode = "auto", -- Auto detect git command
        
        -- Update signs and highlights on CursorHold
        update_debounce = 100,
        
        -- Status signs should be updated on editor idle
        status_formatter = nil, -- Use default
        
        -- Max file size (in lines) for which to enable signs
        max_file_length = 40000,
        
        -- Preview popup configuration
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        
        -- Cursor position mapping
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          
          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })
          
          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })
          
          -- Actions
          map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>gs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Stage selected hunk" })
          map("v", "<leader>gr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Reset selected hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>gb", function() gs.blame_line { full = true } end, { desc = "Blame line" })
          map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
          map("n", "<leader>gt", gs.toggle_deleted, { desc = "Toggle deleted" })
          
          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
        
        -- Use LSP for show_deleted
        show_deleted = false,
      })
    end,
  },
}
