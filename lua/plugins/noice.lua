-- lua/plugins/noice.lua
-- Enhanced UI for messages, cmdline and popupmenu

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        -- Command line configuration
        cmdline = {
          enabled = true,
          view = "cmdline_popup", -- "cmdline_popup" or "cmdline"
          opts = {
            win_options = {
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            },
          },
          format = {
            -- Customize command line appearance
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
            input = {}, -- Used by input()
          },
        },
        
        -- Message display options
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        
        -- Popupmenu configuration
        popupmenu = {
          enabled = true,
          backend = "nui", -- "nui" or "cmp"
          kind_icons = {}, -- Use nvim-cmp kind icons
        },
        
        -- Redirect command output to a split
        redirect = {
          view = "popup",
          filter = { event = "msg_show" },
        },
        
        -- Command history
        commands = {
          history = {
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
          },
          last = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = {
              any = {
                { event = "notify" },
                { error = true },
                { warning = true },
                { event = "msg_show", kind = { "" } },
                { event = "lsp", kind = "message" },
              },
            },
            filter_opts = { count = 1 },
          },
          errors = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
        },
        
        -- Notify configuration
        notify = {
          enabled = true,
          view = "notify",
        },
        
        -- LSP progress handling
        lsp = {
          progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- 30fps
            view = "mini",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            silent = false,
            view = nil, -- Use default
            opts = {
              border = {
                style = "rounded",
                padding = { 0, 1 },
              },
              position = { row = 2, col = 0 },
            },
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true,
              luasnip = true,
              throttle = 50,
            },
            view = nil, -- Use default
            opts = {
              border = {
                style = "rounded",
                padding = { 0, 1 },
              },
              position = { row = 2, col = 0 },
            },
          },
          message = {
            enabled = true,
            view = "notify",
            opts = {},
          },
          documentation = {
            view = "hover",
            opts = {
              lang = "markdown",
              render = {
                code_block = { max_width = 80 },
              },
              replace = true,
              border = {
                style = "rounded",
                padding = { 0, 1 },
              },
            },
          },
        },
        
        -- Markdown theming
        markdown = {
          hover = {
            ["|(%S-)|"] = vim.cmd.help, -- pipe
            ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown link
          },
          highlights = {
            ["|%S-|"] = "@text.reference",
            ["@%S+"] = "@parameter",
            ["^%s*(Parameters:)"] = "@text.title",
            ["^%s*(Return:)"] = "@text.title",
            ["^%s*(See also:)"] = "@text.title",
            ["^%s*([-+]) "] = "@markup.list",
          },
        },
        
        -- Health checks
        health = {
          checker = true,
        },
        
        -- Smart file-relative path display
        smart_move = {
          enabled = true,
          excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },
        
        -- Presets
        presets = {
          bottom_search = true, -- Enable bottom search box
          command_palette = true, -- Enable command palette using :Noice command
          long_message_to_split = true, -- Long messages will be sent to a split
          inc_rename = true, -- Enable incremental rename UI
          lsp_doc_border = true, -- Add a border to hover docs and signature help
        },
        
        -- Theming
        views = {
          cmdline_popup = {
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            filter_options = {},
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
          mini = {
            zindex = 100,
            win_options = {
              winblend = 0,
            },
          },
        },
        
        -- Routes to configure message display behavior
        routes = {
          {
            -- Hide write/save messages
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
          {
            -- Hide search count messages ([1/10]) while searching
            filter = {
              event = "msg_show",
              kind = "search_count",
            },
            opts = { skip = true },
          },
          {
            -- Hide LSP finder results
            filter = {
              event = "msg_show",
              kind = "",
              find = "definition",
            },
            opts = { skip = true },
          },
          {
            -- Send long messages to a split
            filter = {
              event = "msg_show",
              min_height = 10,
            },
            view = "messages",
          },
        },
      })
      
      -- Integrate with trouble.nvim
      vim.keymap.set("n", "<leader>xn", function()
        require("noice").cmd("last")
      end, { desc = "Show last notification" })
      
      -- Show message history
      vim.keymap.set("n", "<leader>xm", function()
        require("noice").cmd("history")
      end, { desc = "Show message history" })
      
      -- Clear all notifications
      vim.keymap.set("n", "<leader>xd", function()
        require("noice").cmd("dismiss")
      end, { desc = "Dismiss all notifications" })
      
      -- Configure nvim-notify
      require("notify").setup({
        background_colour = "#000000",
        stages = "fade",
        timeout = 3000,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })
    end,
  },
}
