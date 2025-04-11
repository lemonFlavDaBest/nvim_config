-- lua/plugins/telescope.lua
-- Telescope configuration

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    keys = {
      -- Find files
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find text" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Find word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Find recent files" },
      
      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
      { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "Git files" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
      
      -- File browser
      { "<leader>fe", "<cmd>Telescope file_browser<CR>", desc = "File browser" },
      { "<leader>fd", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "File browser (current dir)" },
      
      -- Project
      { "<leader>fp", "<cmd>Telescope project<CR>", desc = "Projects" },
      
      -- LSP
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
      { "<leader>lr", "<cmd>Telescope lsp_references<CR>", desc = "References" },
      { "<leader>li", "<cmd>Telescope lsp_implementations<CR>", desc = "Implementations" },
      { "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", desc = "Definitions" },
      { "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Type definitions" },
      { "<leader>la", "<cmd>Telescope lsp_code_actions<CR>", desc = "Code actions" },
      
      -- Misc
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>ft", "<cmd>Telescope filetypes<CR>", desc = "Filetypes" },
      { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Jump to mark" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = telescope.extensions.file_browser.actions
      
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          -- Set border style for telescope windows
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          -- Configure file ignore patterns
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.DS_Store",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
            "target/",
            "build/",
            "dist/",
            "%.o",
            "%.a",
            "%.out",
            "%.so",
            "%.pyc",
            "__pycache__/",
            "%.swp",
            "%.swo",
          },
          -- Configure mappings
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              
              ["<C-c>"] = actions.close,
              ["<Esc>"] = actions.close,
              
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              
              ["<C-l>"] = actions.complete_tag,
              ["<C-h>"] = actions.which_key,
            },
            
            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,
              
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
            follow = true,
          },
          live_grep = {
            additional_args = function(opts)
              return {"--hidden"}
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              i = {
                ["<C-w>"] = function() vim.cmd("normal vbd") end,
                ["<C-h>"] = fb_actions.goto_parent_dir,
                ["<C-c>"] = fb_actions.create,
                ["<C-r>"] = fb_actions.rename,
                ["<C-d>"] = fb_actions.remove,
                ["<C-y>"] = fb_actions.copy,
                ["<C-m>"] = fb_actions.move,
              },
              n = {
                ["h"] = fb_actions.goto_parent_dir,
                ["/"] = function() vim.cmd("startinsert") end,
                ["c"] = fb_actions.create,
                ["r"] = fb_actions.rename,
                ["d"] = fb_actions.remove,
                ["y"] = fb_actions.copy,
                ["m"] = fb_actions.move,
              },
            },
          },
          project = {
            base_dirs = {
              {"~/projects"},
              {"~/.config/nvim"},
            },
            hidden_files = true,
            theme = "dropdown",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })
      
      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("project")
      telescope.load_extension("ui-select")
    end,
  },
}
