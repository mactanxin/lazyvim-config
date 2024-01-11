return {
  {
    "Shatur/neovim-ayu",
    lazy = true,
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
        hide_fillchars = true,
        borderless_telescope = true,
      })
      -- vim.cmd("colorscheme cyberdream") -- set the colorscheme
    end,
  },
  --
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight",
      colorscheme = "cyberdream",
    },
  },
}
