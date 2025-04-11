-- lua/plugins/tmux.lua
-- Tmux integration with Neovim

return {
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    config = function()
      -- Set up seamless navigation between tmux panes and Neovim splits
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_save_on_switch = 2 -- 2 means save all buffers on switch
      vim.g.tmux_navigator_disable_when_zoomed = 1 -- Disable when zoomed
      vim.g.tmux_navigator_preserve_zoom = 1 -- Preserve zoom when navigating

      -- Navigate between both Neovim splits and tmux panes with the same key bindings
      vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { silent = true })
      vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { silent = true })
      vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { silent = true })
      vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { silent = true })
      vim.keymap.set("n", "<C-\\>", ":<C-U>TmuxNavigatePrevious<CR>", { silent = true })
    end,
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
    config = function()
      -- Set up Vimux configuration
      vim.g.VimuxHeight = "30" -- Set height of Vimux runner pane
      vim.g.VimuxOrientation = "h" -- Split horizontally
      vim.g.VimuxUseNearest = 1 -- Use nearest pane if possible
      vim.g.VimuxResetSequence = "q C-u" -- Reset sequence when interrupting
      vim.g.VimuxPromptString = "Command: " -- Prompt string
      vim.g.VimuxRunnerType = "pane" -- Use tmux panes (not windows)
      vim.g.VimuxCloseOnExit = 0 -- Don't close the runner pane when exiting Vim
      
      -- Create some useful functions for sending commands to tmux
      
      -- Run current file based on filetype
      vim.api.nvim_create_user_command("VimuxRunFile", function()
        local cmds = {
          python = "python3 %",
          lua = "lua %",
          ruby = "ruby %",
          javascript = "node %",
          typescript = "ts-node %",
          rust = "cargo run",
          go = "go run %",
          sh = "sh %",
          bash = "bash %",
          zsh = "zsh %",
          markdown = "mdcat %",
          solidity = "forge test",
        }
        
        local ft = vim.bo.filetype
        local cmd = cmds[ft]
        
        if cmd then
          -- Get the current file path relative to the current directory
          local filepath = vim.fn.expand("%")
          -- Replace % with the file path
          cmd = cmd:gsub("%%", filepath)
          -- Run the command
          vim.cmd(string.format("VimuxRunCommand '%s'", cmd))
        else
          vim.notify("No run command defined for filetype: " .. ft, vim.log.levels.WARN)
        end
      end, {})
      
      -- Map to run current file
      vim.keymap.set("n", "<leader>tc", ":VimuxRunFile<CR>", { desc = "Run current file in Tmux" })
      
      -- Create tmux session with fzf
      vim.api.nvim_create_user_command("TmuxSessionizer", function()
        -- Check if tmux-sessionizer exists
        local sessionizer_exists = vim.fn.system("command -v tmux-sessionizer || echo 'not found'")
        if sessionizer_exists ~= "not found" then
          vim.cmd("silent !tmux-sessionizer")
        else
          -- Fallback to basic tmux session creation
          vim.cmd("silent !tmux new-session -d -s $(basename $(pwd))")
          vim.notify("Created new tmux session: " .. vim.fn.system("basename $(pwd)"):gsub("\n", ""))
        end
      end, {})
      
      -- Map for tmux-sessionizer
      vim.keymap.set("n", "<C-f>", ":TmuxSessionizer<CR>", { silent = true, desc = "Tmux sessionizer" })
      
      -- Function to get current Tmux session name
      local function get_tmux_session()
        if vim.fn.exists("$TMUX") == 1 then
          local handle = io.popen("tmux display-message -p '#S'")
          if handle then
            local session = handle:read("*a"):gsub("\n", "")
            handle:close()
            return session
          end
        end
        return nil
      end
      
      -- Display tmux session in command bar
      vim.api.nvim_create_user_command("TmuxSession", function()
        local session = get_tmux_session()
        if session then
          vim.notify("Current tmux session: " .. session)
        else
          vim.notify("Not inside a tmux session")
        end
      end, {})
      
      -- Initialize tmux autocommands if inside tmux
      if vim.fn.exists("$TMUX") == 1 then
        local tmux_augroup = vim.api.nvim_create_augroup("TmuxIntegration", { clear = true })
        
        -- Update tmux window name with current file
        vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "BufWritePost" }, {
          group = tmux_augroup,
          callback = function()
            local filename = vim.fn.expand("%:t")
            if filename ~= "" then
              vim.fn.system("tmux rename-window " .. filename)
            end
          end,
        })
        
        -- Reset tmux window name when leaving Neovim
        vim.api.nvim_create_autocmd("VimLeave", {
          group = tmux_augroup,
          callback = function()
            vim.fn.system("tmux set-window-option automatic-rename on >/dev/null")
          end,
        })
      end
      
      -- Create a helper for ghostty-tmux integration if using ghostty
      if vim.g.ghostty_terminal then
        -- Set up ghostty-specific tmux integration
        vim.api.nvim_create_user_command("GhosttyTmuxFloatToggle", function()
          vim.fn.system("ghostty tmux popup -w 80% -h 80%")
        end, {})
        
        -- Map for ghostty-tmux popup
        vim.keymap.set("n", "<leader>tg", ":GhosttyTmuxFloatToggle<CR>", { silent = true, desc = "Ghostty tmux popup" })
      end
    end,
  },
  {
    "tmux-plugins/vim-tmux-focus-events",
    event = "VeryLazy",
    config = function()
      -- Enable focus events in tmux
      vim.g.tmux_focus_events = 1
      
      -- Ensure autoread works with tmux focus events
      vim.o.autoread = true
      
      -- Create autocommands for focus events
      local focus_augroup = vim.api.nvim_create_augroup("FocusEvents", { clear = true })
      
      -- Check file changes on focus gain
      vim.api.nvim_create_autocmd("FocusGained", {
        group = focus_augroup,
        command = "checktime",
      })
      
      -- Make sure to write unsaved changes when focus is lost
      vim.api.nvim_create_autocmd("FocusLost", {
        group = focus_augroup,
        command = "silent! wa",
      })
    end,
  },
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    config = function()
      require("tmux").setup({
        -- Custom copy/paste integration
        copy_sync = {
          enable = true,
          redirect_to_clipboard = true,
          sync_clipboard = true,
          sync_registers = true,
          sync_deletes = true,
          clear_on_select = true,
        },
        -- Tmux window navigation
        navigation = {
          -- Already handled by vim-tmux-navigator
          enable_default_keybindings = false,
        },
        -- Tmux window resizing
        resize = {
          enable_default_keybindings = false,
          -- Set up custom resize bindings
          resize_step_x = 5,
          resize_step_y = 5,
        },
      })
      
      -- Custom resize bindings
      vim.keymap.set("n", "<M-h>", require("tmux").resize_left, { desc = "Resize tmux left" })
      vim.keymap.set("n", "<M-j>", require("tmux").resize_bottom, { desc = "Resize tmux down" })
      vim.keymap.set("n", "<M-k>", require("tmux").resize_top, { desc = "Resize tmux up" })
      vim.keymap.set("n", "<M-l>", require("tmux").resize_right, { desc = "Resize tmux right" })
    end,
  },
}
