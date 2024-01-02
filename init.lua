-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  -- Helper function for transparency formatting
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
  end
  vim.o.guifont = "Hack Nerd Font:h20"
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 0.8
  vim.g.neovide_background_color = "#0f1117" .. alpha()
end

-- copyright @xin 2024
