return {
  {
    "Shatur/neovim-ayu",
    lazy = true,
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
      })
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Recommended - see "Configuring" below for more config options
        transparent = true,
        italic_comments = true,
        hide_fillchars = false,
        borderless_telescope = true,
      })
      -- require("notify").setup({
      --   background_colour = "#000000",
      -- })
      -- vim.cmd("colorscheme cyberdream") -- set the colorscheme
    end,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = true, -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    transparent = true,
    opts = {
      style = "moon",
      transparent = true,
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  --
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
      -- style = "storm",
      -- colorscheme = "onedark",
      -- colorscheme = "cyberdream",
    },
  },
}
