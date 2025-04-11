-- lua/plugins/harpoon.lua
-- Fast file navigation with ThePrimeagen's Harpoon 2

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2", -- Make sure to use harpoon2 branch
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false, -- Load Harpoon at startup
    config = function()
      local harpoon = require("harpoon")
      
      -- Basic Harpoon setup - fixed to use proper table structure
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          save_on_change = true,
          key = function() 
            return vim.loop.cwd() 
          end
        }
      })

      -- File operations
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end,
        { desc = "Harpoon add file" })
      
      -- Menu operations
      vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, 
        { desc = "Harpoon menu" })
      
      -- Quickly jump to files 1-9
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end,
        { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end,
        { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end,
        { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end,
        { desc = "Harpoon file 4" })
      vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end,
        { desc = "Harpoon file 5" })
      
      -- Navigation between marks
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end,
        { desc = "Harpoon prev file" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end,
        { desc = "Harpoon next file" })

      -- Create Telescope extension for Harpoon if Telescope is loaded
      local function create_telescope_extension()
        local telescope_status_ok, telescope = pcall(require, "telescope")
        if telescope_status_ok then
          local conf = require("telescope.config").values
          local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
            end
            
            require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                results = file_paths,
              }),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, map)
                local actions = require("telescope.actions")
                
                -- Map enter to select the file
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = require("telescope.actions.state").get_selected_entry()
                  for i, item in ipairs(harpoon_files.items) do
                    if item.value == selection.value then
                      harpoon:list():select(i)
                    end
                  end
                end)
                return true
              end,
            }):find()
          end
          
          telescope.register_extension({
            exports = {
              harpoon = function()
                toggle_telescope(harpoon:list())
              end,
            },
          })
          
          -- Add telescope integration for fuzzy finding harpoon marks
          vim.keymap.set("n", "<leader>hf", "<cmd>Telescope harpoon<CR>", 
            { desc = "Telescope Harpoon marks" })
        end
      end
      
      -- Try to create the Telescope extension (will only work if Telescope is loaded)
      create_telescope_extension()
      
      -- Setup automatic update for Harpoon marks file on certain events
      vim.api.nvim_create_autocmd({ "BufLeave", "VimLeave" }, {
        callback = function()
          require("harpoon"):sync()
        end,
      })
      
      -- Define advanced functions for manipulating marks
      
      -- Clear all marks
      vim.keymap.set("n", "<leader>hc", function()
        local list = harpoon:list()
        list:clear()
        vim.notify("Harpoon marks cleared", vim.log.levels.INFO)
      end, { desc = "Clear all Harpoon marks" })
      
      -- Swap current buffer with first mark
      vim.keymap.set("n", "<leader>hs", function()
        local list = harpoon:list()
        local current_file = vim.fn.expand("%:p")
        local idx = list:get_current_index()
        if not idx then
          vim.notify("Current file not in Harpoon list", vim.log.levels.WARN)
          return
        end
        -- Swap with the first item
        if idx > 1 then
          list:swap(idx, 1)
          vim.notify("Swapped with first Harpoon mark", vim.log.levels.INFO)
        end
      end, { desc = "Swap with first Harpoon mark" })
      
      -- Move the current file to a specific position in the list
      vim.keymap.set("n", "<leader>hm1", function()
        local list = harpoon:list()
        local current_file = vim.fn.expand("%:p")
        local idx = list:get_current_index()
        if not idx then
          list:append()
          idx = list:length()
        end
        if idx > 1 then
          list:swap(idx, 1)
          vim.notify("Moved to position 1", vim.log.levels.INFO)
        end
      end, { desc = "Move to Harpoon position 1" })
    end,
  }
}
