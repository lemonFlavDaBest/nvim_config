-- lua/core/keymaps.lua
-- Key mappings configuration

local map = vim.keymap.set

-- Helper function for mapping
local function nmap(lhs, rhs, desc)
  map("n", lhs, rhs, { desc = desc, noremap = true, silent = true })
end

local function vmap(lhs, rhs, desc)
  map("v", lhs, rhs, { desc = desc, noremap = true, silent = true })
end

local function imap(lhs, rhs, desc)
  map("i", lhs, rhs, { desc = desc, noremap = true, silent = true })
end

local function tmap(lhs, rhs, desc)
  map("t", lhs, rhs, { desc = desc, noremap = true, silent = true })
end

-- Use jk to exit insert mode
imap("jk", "<Esc>", "Exit insert mode")

-- Center search results
nmap("n", "nzz", "Center search result")
nmap("N", "Nzz", "Center search result (reverse)")

-- Clear search highlights
nmap("<leader>h", ":nohlsearch<CR>", "Clear search highlights")

-- Better window navigation
nmap("<C-h>", "<C-w>h", "Navigate to left window")
nmap("<C-j>", "<C-w>j", "Navigate to bottom window")
nmap("<C-k>", "<C-w>k", "Navigate to top window")
nmap("<C-l>", "<C-w>l", "Navigate to right window")

-- Window management
nmap("<leader>sv", ":vsplit<CR>", "Split vertically")
nmap("<leader>sh", ":split<CR>", "Split horizontally")
nmap("<leader>se", "<C-w>=", "Make splits equal size")
nmap("<leader>sx", ":close<CR>", "Close current split")

-- Resize windows with arrows
nmap("<C-Up>", ":resize -2<CR>", "Decrease window height")
nmap("<C-Down>", ":resize +2<CR>", "Increase window height")
nmap("<C-Left>", ":vertical resize -2<CR>", "Decrease window width")
nmap("<C-Right>", ":vertical resize +2<CR>", "Increase window width")

-- Navigate buffers
nmap("<S-l>", ":bnext<CR>", "Next buffer")
nmap("<S-h>", ":bprevious<CR>", "Previous buffer")
nmap("<leader>bd", ":Bdelete<CR>", "Delete buffer")
nmap("<leader>bn", ":enew<CR>", "New buffer")

-- Better indenting
vmap("<", "<gv", "Indent left")
vmap(">", ">gv", "Indent right")

-- Move text up and down
nmap("<A-j>", ":m .+1<CR>==", "Move line down")
nmap("<A-k>", ":m .-2<CR>==", "Move line up")
vmap("<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
vmap("<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

-- Tab management
nmap("<leader>tn", ":tabnew<CR>", "New tab")
nmap("<leader>tc", ":tabclose<CR>", "Close tab")
nmap("<leader>to", ":tabonly<CR>", "Close all other tabs")
nmap("<leader>tt", ":tabnext<CR>", "Next tab")
nmap("<leader>tp", ":tabprevious<CR>", "Previous tab")

-- Quickfix list navigation
nmap("[q", ":cprevious<CR>", "Previous quickfix item")
nmap("]q", ":cnext<CR>", "Next quickfix item")
nmap("[Q", ":cfirst<CR>", "First quickfix item")
nmap("]Q", ":clast<CR>", "Last quickfix item")

-- Location list navigation
nmap("[l", ":lprevious<CR>", "Previous location item")
nmap("]l", ":lnext<CR>", "Next location item")
nmap("[L", ":lfirst<CR>", "First location item")
nmap("]L", ":llast<CR>", "Last location item")

-- Terminal mode mappings
tmap("<Esc>", "<C-\\><C-n>", "Exit terminal mode")
tmap("<C-h>", "<C-\\><C-n><C-w>h", "Navigate to left window from terminal")
tmap("<C-j>", "<C-\\><C-n><C-w>j", "Navigate to bottom window from terminal")
tmap("<C-k>", "<C-\\><C-n><C-w>k", "Navigate to top window from terminal")
tmap("<C-l>", "<C-\\><C-n><C-w>l", "Navigate to right window from terminal")

-- Save file
nmap("<C-s>", ":w<CR>", "Save file")
imap("<C-s>", "<Esc>:w<CR>a", "Save file in insert mode")

-- Quit
nmap("<leader>q", ":q<CR>", "Quit")
nmap("<leader>Q", ":qa!<CR>", "Quit without saving")
nmap("<leader>wq", ":wq<CR>", "Save and quit")

-- Plugin-specific keymaps (commented out for now)
-- Will be defined in respective plugin configuration files

-- NvimTree
nmap("<leader>e", ":NvimTreeToggle<CR>", "Toggle file explorer")
nmap("<leader>o", ":NvimTreeFocus<CR>", "Focus file explorer")

-- Telescope
nmap("<leader>ff", "<cmd>Telescope find_files<CR>", "Find files")
nmap("<leader>fg", "<cmd>Telescope live_grep<CR>", "Find text")
nmap("<leader>fb", "<cmd>Telescope buffers<CR>", "Find buffers")
nmap("<leader>fh", "<cmd>Telescope help_tags<CR>", "Find help")
nmap("<leader>fr", "<cmd>Telescope oldfiles<CR>", "Find recent files")

-- LSP keybindings (will be set in lsp setup)

-- Harpoon 2
nmap("<leader>a", function() require("harpoon"):list():append() end, "Harpoon mark file")
nmap("<leader>m", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, "Harpoon menu")
nmap("<leader>1", function() require("harpoon"):list():select(1) end, "Harpoon to file 1")
nmap("<leader>2", function() require("harpoon"):list():select(2) end, "Harpoon to file 2")
nmap("<leader>3", function() require("harpoon"):list():select(3) end, "Harpoon to file 3")
nmap("<leader>4", function() require("harpoon"):list():select(4) end, "Harpoon to file 4")

-- Toggleterm
nmap("<leader>tf", "<cmd>ToggleTerm direction=float<CR>", "Terminal float")
nmap("<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", "Terminal horizontal")
nmap("<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", "Terminal vertical")
nmap("<F7>", "<cmd>ToggleTerm<CR>", "Toggle terminal")

-- Git keymaps
nmap("<leader>gs", "<cmd>Git<CR>", "Git status")
nmap("<leader>gd", "<cmd>Gdiffsplit<CR>", "Git diff")
nmap("<leader>gc", "<cmd>Git commit<CR>", "Git commit")
nmap("<leader>gb", "<cmd>Git blame<CR>", "Git blame")
nmap("<leader>gl", "<cmd>Git log<CR>", "Git log")
nmap("<leader>gp", "<cmd>Git push<CR>", "Git push")

-- Tmux
nmap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", "Tmux sessionizer")
