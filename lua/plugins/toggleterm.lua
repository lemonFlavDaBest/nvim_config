-- lua/plugins/toggleterm.lua
-- Terminal configuration

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (float)" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical)" },
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<F7>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    config = function()
      local terminal = require("toggleterm")
      
      terminal.setup({
        -- Size configuration
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        
        -- Set the terminal key to F7
        open_mapping = [[<F7>]],
        
        -- Hide line numbers in terminal
        hide_numbers = true,
        
        -- Terminal shade settings
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        
        -- Always start in insert mode
        start_in_insert = true,
        
        -- Allow mappings while in insert mode
        insert_mappings = true,
        
        -- Save terminal size
        persist_size = true,
        
        -- Default direction
        direction = "float",
        
        -- Close terminal when the process exits
        close_on_exit = true,
        
        -- Use current shell
        shell = vim.o.shell,
        
        -- Floating window configuration
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
      
      -- Define specialized terminals for different purposes
      
      -- Create a LazyGit terminal
      local lazygit = require("toggleterm.terminal").Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        -- Go back to normal mode after exit
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function(_)
          vim.cmd("startinsert!")
        end,
      })
      
      -- Function to toggle lazygit
      function _G.lazygit_toggle()
        lazygit:toggle()
      end
      
      -- Map keys for the custom terminals
      vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua lazygit_toggle()<CR>", { noremap = true, silent = true })
      
      -- Create a terminal for Python
      local python_term = require("toggleterm.terminal").Terminal:new({
        cmd = "python",
        hidden = true,
        direction = "float",
      })
      
      function _G.python_toggle()
        python_term:toggle()
      end
      
      vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>lua python_toggle()<CR>", { noremap = true, silent = true })
      
      -- Create a terminal for Rust 
      local rust_term = require("toggleterm.terminal").Terminal:new({
        cmd = "cargo run",
        hidden = true,
        direction = "float",
        on_open = function(term)
          -- Check if we're in a Rust project
          local cargo_file = vim.fn.findfile("Cargo.toml", ".;")
          if cargo_file == "" then
            term:change_cmd("echo 'Not in a Rust project (no Cargo.toml found)'")
          end
        end,
      })
      
      function _G.rust_toggle()
        rust_term:toggle()
      end
      
      vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>lua rust_toggle()<CR>", { noremap = true, silent = true })
      
      -- Create a terminal for Solidity
      local solidity_term = require("toggleterm.terminal").Terminal:new({
        cmd = "npx hardhat console",
        hidden = true,
        direction = "float",
        on_open = function(term)
          -- Check if we're in a Hardhat or Foundry project
          local hardhat_config = vim.fn.findfile("hardhat.config.js", ".;") .. vim.fn.findfile("hardhat.config.ts", ".;")
          local foundry_config = vim.fn.findfile("foundry.toml", ".;")
          
          if hardhat_config == "" and foundry_config ~= "" then
            term:change_cmd("forge console")
          elseif hardhat_config == "" and foundry_config == "" then
            term:change_cmd("echo 'No Hardhat or Foundry project detected'")
          end
        end,
      })
      
      function _G.solidity_toggle()
        solidity_term:toggle()
      end
      
      vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>lua solidity_toggle()<CR>", { noremap = true, silent = true })
      
      -- Configure terminal modes
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end
      
      -- Auto command to set up terminal keymaps when entering term mode
      vim.cmd([[
        augroup terminal_keymaps
          autocmd!
          autocmd TermOpen * lua set_terminal_keymaps()
        augroup END
      ]])
    end,
  },
}
