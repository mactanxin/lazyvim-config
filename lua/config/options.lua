-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 2, -- so that `` is visible in markdown files
  concealcursor = "",
  encoding = "utf-8",
  -- fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showcmd = true,
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  -- showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  shiftround = true,
  autowrite = true,
  softtabstop = 2,
  autoindent = true,
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  -- wrap = false, -- display lines as one long line
  wrap = true, -- break lines if they are longer than the width of the window
  scrolloff = 8, -- is one of my fav
  sidescrolloff = 8,
  guifont = "MesloLGS  NF:h16", -- the font used in graphical neovim applications
  title = true, -- title of  :set all 、:autocmd
  backspace = "start,eol,indent",
  laststatus = 2,
  foldmethod = "syntax", -- manual: 手动定义折叠；indent: 更多的缩进表示更高级别的折叠; expr: 用表达式定义折叠; syntax: 用语法高亮来定义折叠; diff: 对没有更改的文本进行折叠; marker: 对文中的标志进行折叠
  shell = "zsh",
}

vim.opt.shortmess:append("c")
-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
-- vim.g.lazyvim_picker = "telescope"

for k, v in pairs(options) do
  vim.opt[k] = v
end
