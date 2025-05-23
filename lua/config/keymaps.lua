-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
-- keymap("", ";", ":", opts)

local function mapkey(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end

local function mapcmd(key, cmd)
  vim.api.nvim_set_keymap("n", key, ":" .. cmd .. "<cr>", { noremap = true })
end

local function maplua(key, txt)
  vim.api.nvim_set_keymap("n", key, ":lua " .. txt .. "<cr>", { noremap = true })
end

local function is_available(plugin)
  return packer_plugins ~= nil and packer_plugins[plugin] ~= nil
end

local function toast(msg, level)
  vim.notify(msg, level, {
    title = "My custom notification",
    timeout = 5000,
  })
end

vim.cmd([[

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
]])
--Remap space as leader key
--
-- mapcmd("s", "<Nop>")
-- mapcmd("S", "<Nop>")
-- mapcmd("R", "<Nop>")
mapcmd("<LEADER><CR>", "noh")
mapcmd("<Leader>O", "%bd|e#|bd#")

mapcmd("<LEADER>d", "Alpha")

mapkey("n", "<LEADER>m", ":call mkdir(expand('%:p:h'), 'p')<CR>")

mapkey("n", "[b", ":bprevious<CR>")
mapkey("n", "]b", ":bnext<CR>")
mapkey("n", "[B", ":bfirst<CR>")
mapkey("n", "]B", ":blast<CR>")

mapkey("n", "+", "<C-a>")
mapkey("n", "-", "<C-x>")

mapkey("x", "<leader>o", '"_dP')
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--
keymap(
  "n",
  "<C-s>",
  ":lua if vim.bo.filetype == 'vue' or vim.bo.filetype == 'typescript' then vim.cmd('EslintFixAll') end; <CR> :w<CR>",
  opts
)

-- mapkey("n", "S", ":wq")
--select all text
mapkey("n", "<C-a>", "gg<S-v>G")
keymap("n", "Q", ":q<CR>", opts)
keymap("n", "Z", ":wq<CR>", opts)
-- mapcmd("R", "ReloadConfig<CR>")
keymap("", "cd", ":chdir", opts)

-- Visual --
-- Stay in indent mode
if is_available("Comment.nvim") then
  keymap("v", "<", "<gv", opts)
  keymap("v", ">", ">gv", opts)
end

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- -- Toggle NERDTree
mapcmd("<leader>tt", ":lua Snacks.explorer()")
mapcmd("<LEADER>r", ":NvimTreeRefresh")
keymap("n", "<LEADER>p", ":w | !open %<CR>", opts) -- live preview files using dufault App

-- jump back and forth in frames
mapkey("n", "<C-l>", "<C-w>l")
mapkey("n", "<C-h>", "<C-w>h")
mapkey("n", "<C-j>", "<C-w>j")
mapkey("n", "<C-k>", "<C-w>k")
mapkey("n", "<LEADER><LEADER>", ":lua Snacks.dashboard.pick('files')<CR>")
mapkey("n", "<LEADER>bb", "<C-b>")
mapkey("n", ";sv", "<C-w>t<C-w>H<CR>")
mapkey("n", ";sh", "<C-w>t<C-w>K<CR>")

-- Comment
-- maplua("<LEADER>/", 'require("Comment.api").locked("toggle.linewise.current")()')
-- keymap(
--   "v",
--   "<LEADER>/",
--   '<esc><cmd>lua require("Comment.api").locked("comment.linewise")(vim.fn.visualmode())<CR>',
--   opts
-- )
vim.keymap.set("n", "<leader>sr", "", {
  silent = true,
  desc = "reload init.lua",
  callback = function()
    vim.cmd([[
      source $MYVIMRC
    ]])
    vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
  end,
})

keymap("", "<LEADER>cd", ":cd %:p:h<CR>:pwd<CR>", opts)
mapcmd("<LEADER>ss", ":SaveSession")
mapcmd("<LEADER>sl", ":RestoreSession")

-- GoTo Tabs by number
keymap("", "<LEADER>1", "1gt", opts)
keymap("", "<LEADER>2", "2gt", opts)
keymap("", "<LEADER>3", "3gt", opts)
keymap("", "<LEADER>4", "4gt", opts)
keymap("", "<LEADER>5", "5gt", opts)
keymap("", "<LEADER>6", "6gt", opts)
keymap("", "<LEADER>7", "7gt", opts)
keymap("", "<LEADER>8", "8gt", opts)
keymap("", "<LEADER>9", "9gt", opts)
keymap("", "<LEADER>9", "9gt", opts)
keymap("", "<LEADER>0", ":tablast<CR>", opts)

-- split
mapcmd("<leader>sl", "set splitright<CR>:vsplit<CR>")
mapcmd("<leader>sh", "set nosplitright<CR>:vsplit<CR>")
mapcmd("<leader>sk", "set splitbelow<CR>:split<CR>")
mapcmd("<leader>sj", "set splitbelow<CR>:split<CR>")

-- change split size using alt+arrow
mapcmd("<M-left>", "vertical resize -5<cr>")
mapcmd("<M-down>", "resize +5<cr>")
mapcmd("<M-up>", "resize -5<cr>")
mapcmd("<M-right>", "vertical resize +5<cr>")

mapcmd("tn", "tabe")
mapcmd("th", "-tabnext")
mapcmd("tl", "+tabnext")

-- mapkey("n", ";ff", "<cmd>Telescope find_files hidden=true<CR>")
-- mapkey("n", ";fg", "<cmd>Telescope live_grep<cr>")
-- mapkey("n", ";fc", "<cmd>Telescope git_commits<CR>")
-- mapkey("n", ";fb", "<cmd>Telescope buffers<cr>")
-- mapkey("n", ";fh", "<cmd>Telescope help_tags<cr>")
-- mapkey("n", ";ft", "<cmd>Telescope notify<cr>")
-- maplua(";fs", "require('session-lens').search_session()")
-- maplua(";fp", "require('ui.theme_picker').open_picker()<cr>")
-- mapkey("n", ";fe", "<cmd>Telescope file_browser<cr>")
-- mapkey("n", ";ds", "<cmd>Telescope lsp_document_symbols<cr>")
-- mapkey("n", ";lso", "<cmd>Lspsaga outline<CR>")
-- mapkey("n", "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
-- mapkey("t", "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

-- vim.keymap.set({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
-- telescope git commands
-- mapkey("n", ";gc", "<cmd>Telescope git_commits<cr>")
-- mapkey("n", ";gbc", "<cmd>Telescope git_bcommits<cr>")
-- mapkey("n", ";gbr", "<cmd>Telescope git_branches<cr>")
-- mapkey("n", ";gst", "<cmd>Telescope git_status<cr>")
--[[ maplua("<leader>fs", "require('session-lens').search_session()") ]]
maplua("<leader>cn", "require('notify').dismiss()<cr>", opts)
-- SarchBox Key Bindings
mapcmd("<LEADER>rs", "SearchBoxIncSearch")
mapcmd("<LEADER>rr", "SearchBoxReplace confirm=menu")

-- EasyMotion
-- keymap("n", "s", "<Plug>(easymotion-bd-f)", opts)

-- EasyAlign
mapcmd("ga", ":EasyAlign<CR>", opts)

-- Diff View
mapcmd("<LEADER>df", ":DiffviewOpen<CR>")

-- PeepSight
mapcmd("<LEADER>pp", ":Peepsight<CR> :lua vim.notify('Peepsight toggled', 'info', { title = 'PeepSight Plugin' })<cr>")

mapkey("n", "<leader>ew", "<C-w>r<cr>")
mapkey("n", "<Leader>", ":WhichKey\r<leader>")
-- toggle null-ls
mapkey("n", "<leader>tn", ":lua require('null-ls').toggle({})<cr>")

-- TreeSJ
mapcmd("T", ":TSJToggle<CR>")
mapkey("n", "<leader>J", ":TSJJoin<CR>")
mapkey("n", "<leader>M", ":TSJSplit<CR>")

-- Lsp_lines
mapkey("n", "<leader>ll", ":lua require('lsp_lines').toggle<cr>")

-- NeoAI
mapkey("n", "<leader>ai", ":NeoAI<cr>")

-- Mini.Files
mapkey("n", "<leader>mf", ":lua MiniFiles.open()<cr>")

-- auto add double qoutes in html attribute
-- vim.keymap.set("i", "=", function()
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local left_of_cursor_range = { cursor[1] - 1, cursor[2] - 1 }
--
--   -- The cursor location does not give us the correct node in this case, so we
--   -- need to get the node to the left of the cursor
--   local node = vim.treesitter.get_node({ pos = left_of_cursor_range })
--   local nodes_active_in = { "attribute_name", "directive_argument", "directive_name" }
--   if not node or not vim.tbl_contains(nodes_active_in, node:type()) then
--     return "="
--   end
--
--   return '=""<left>'
-- end, { expr = true, buffer = true })
