-- lua/plugins/bufferline.lua
-- Tab/Buffer line configuration

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "<leader>bc", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
      { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer 6" },
      { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer 7" },
      { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer 8" },
      { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer 9" },
    },
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          mode = "buffers", -- Set to "tabs" for tab mode
          numbers = "none", -- Use "ordinal" for buffer number
          close_command = "Bdelete! %d", -- Command to execute when closing a buffer
          right_mouse_command = "Bdelete! %d", -- Command on right mouse click
          left_mouse_command = "buffer %d", -- Command on left mouse click
          middle_mouse_command = nil, -- Command on middle mouse click
          
          -- Buffer styling
          indicator = {
            icon = "▎", -- The character to use as indicator
            style = "icon", -- Can be "icon", "underline" or "none"
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          
          -- Buffer appearance
          name_formatter = function(buf) -- Format buffer names
            if buf.name:match("%.md") then
              return vim.fn.fnamemodify(buf.name, ":t:r")
            end
          end,
          max_name_length = 18,
          max_prefix_length = 15, -- Maximum prefix filename length
          tab_size = 18,
          diagnostics = "nvim_lsp", -- Using diagnostics from nvim-lsp
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          
          -- Customize icons
          custom_filter = function(buf_number, buf_numbers)
            -- Hide quickfix lists from bufferline
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
            {
              filetype = "DiffviewFiles",
              text = "Diff View",
              text_align = "left",
              separator = true,
            },
          },
          separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
          color_icons = true, -- Whether or not to add the filetype icon highlights
          show_buffer_icons = true, -- Disable filetype icons for buffers
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- Whether or not custom sorted buffers should persist
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = "id", -- 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs'
          groups = {
            options = {
              toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
            },
            items = {
              {
                name = "Tests",
                highlight = { sp = "green" },
                auto_close = false,
                icon = "",
                priority = 2,
                matcher = function(buf)
                  return buf.path:match("_test") or buf.path:match("test_") or buf.path:match("spec")
                end,
              },
              {
                name = "Docs",
                highlight = { sp = "blue" },
                auto_close = false,
                icon = "",
                priority = 3,
                matcher = function(buf)
                  return buf.path:match("%.md") or buf.path:match("%.txt") or buf.path:match("%.rst")
                end,
              },
            },
          },
        },
        -- Custom highlighting/colorscheme integration
        highlights = {
          buffer_selected = {
            italic = false,
            bold = true,
          },
          diagnostic_selected = {
            italic = false,
            bold = true,
          },
          hint_selected = {
            italic = false,
            bold = true,
          },
          hint = {
            italic = false,
          },
          hint_diagnostic = {
            italic = false,
          },
          hint_diagnostic_selected = {
            italic = false,
            bold = true,
          },
          info_selected = {
            italic = false,
            bold = true,
          },
          info = {
            italic = false,
          },
          info_diagnostic = {
            italic = false,
          },
          info_diagnostic_selected = {
            italic = false,
            bold = true,
          },
          warning_selected = {
            italic = false,
            bold = true,
          },
          warning = {
            italic = false,
          },
          warning_diagnostic = {
            italic = false,
          },
          warning_diagnostic_selected = {
            italic = false,
            bold = true,
          },
          error_selected = {
            italic = false,
            bold = true,
          },
          error = {
            italic = false,
          },
          error_diagnostic = {
            italic = false,
          },
          error_diagnostic_selected = {
            italic = false,
            bold = true,
          },
          duplicate = {
            italic = false,
          },
          duplicate_selected = {
            italic = false,
            bold = true,
          },
          modified = {
            italic = false,
          },
          modified_selected = {
            italic = false,
            bold = true,
          },
        },
      })
    end,
  },
}
