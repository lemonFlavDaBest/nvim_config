-- lua/plugins/lualine.lua
-- Statusline configuration

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end
      
      -- Get harpoon status
      local function harpoon_component()
        local harpoon_avail, harpoon = pcall(require, "harpoon")
        if harpoon_avail then
          local hm = harpoon:list()
          if hm and hm:length() > 0 then
            local curr_buf_idx = hm:get_current_index()
            local indices = {}
            if curr_buf_idx and curr_buf_idx > 0 then
              indices[#indices+1] = curr_buf_idx
            end
            
            local marked_buffers = {}
            for i = 1, math.min(hm:length(), 4) do
              marked_buffers[i] = hm:get(i).value and vim.fn.fnamemodify(hm:get(i).value, ":t") or ""
              if #marked_buffers[i] > 10 then
                marked_buffers[i] = marked_buffers[i]:sub(1, 9) .. "…"
              end
              
              -- Add index to list if not the current buffer
              if not vim.tbl_contains(indices, i) then
                indices[#indices+1] = i
              end
            end
            
            -- Format strings
            local result = {}
            for _, idx in ipairs(indices) do
              if idx == curr_buf_idx then
                result[#result+1] = string.format("[%d:%s]", idx, marked_buffers[idx])
              else
                result[#result+1] = string.format("%d:%s", idx, marked_buffers[idx])
              end
            end
            
            return table.concat(result, " ")
          end
        end
        return ""
      end
      
      -- Configure LSP progress
  local function lsp_progress()
  -- Use vim.lsp.status() instead of deprecated function
  if vim.lsp.status then
    local status = vim.lsp.status()
    if status and status ~= "" then
      return status
    end
  else
    -- Fallback for older Neovim versions
    local messages = vim.lsp.util.get_progress_messages()
    if #messages == 0 then
      return ""
    end
    local status = {}
    for _, msg in pairs(messages) do
      table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
    end
    return table.concat(status, " | ")
  end
  return ""
end   
      -- Show current function
      local function lsp_function()
        local function_string = vim.b.lsp_current_function
        if not function_string or function_string == "" then
          return ""
        end
        -- Limit the length of the function string
        if #function_string > 30 then
          function_string = function_string:sub(1, 27) .. "..."
        end
        return function_string
      end
      
      -- Show tmux session
      local function tmux_session()
        local session = os.getenv("TMUX_PANE")
        if session then
          local cmd = "tmux display-message -p '#S'"
          local handle = io.popen(cmd)
          if handle then
            local result = handle:read("*a")
            handle:close()
            return result:gsub("%s+", "")
          end
        end
        return ""
      end
      
      -- Mode display
      local mode_map = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        [""] = "V-BLOCK",
        c = "COMMAND",
        R = "REPLACE",
        t = "TERMINAL",
        s = "SELECT",
        S = "S-LINE",
        [""] = "S-BLOCK",
      }
      
      local function mode_function()
        return mode_map[vim.fn.mode()] or vim.fn.mode()
      end
      
      -- Show current project
      local function project_name()
        local cwd = vim.fn.getcwd()
        local home = os.getenv("HOME")
        local project = vim.fn.fnamemodify(cwd, ":t")
        local parent = vim.fn.fnamemodify(cwd, ":h:t")
        
        if cwd == home then
          return "~"
        end
        
        if parent ~= "/" then
          return parent .. "/" .. project
        end
        
        return project
      end
      
      -- Setup lualine
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
            winbar = { "dashboard", "alpha", "NvimTree" },
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            { mode_function },
          },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", source = diff_source, symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filename", path = 1 },
            { lsp_function, icon = " " },
            { lsp_progress },
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = {
            { harpoon_component, icon = "󰛢 " },
            { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } },
            {
              function()
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                if next(clients) == nil then
                  return "No LSP"
                end
                
                local client_names = {}
                for _, client in ipairs(clients) do
                  table.insert(client_names, client.name)
                end
                
                return "LSP: " .. table.concat(client_names, ", ")
              end,
              icon = " ",
            },
            { "encoding" },
            { "fileformat" },
            { "filetype", icon_only = false },
          },
          lualine_y = {
            { tmux_session, icon = "󰍹 " },
            { "progress" },
          },
          lualine_z = {
            { "location" },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {
          lualine_a = {
            { project_name, icon = "󰉋 " },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {
          "nvim-tree",
          "toggleterm",
          "quickfix",
          "fugitive",
        },
      })
    end,
  },
}
