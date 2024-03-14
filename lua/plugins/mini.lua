-- Setting specific file types does not work
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })
      require("mini.cursorword").setup()
      require("mini.bracketed").setup()
      -- require("mini.jump").setup()
      require("mini.animate").setup({
        open = { enable = false },
        close = { enable = false },
      })
      require("mini.files").setup({
        options = {
          use_as_default_explorer = true,
        },
        windows = {
          -- Maximum number of windows to show side by side
          max_number = math.huge,
          -- Whether to show preview of directory under cursor
          preview = true,
          -- Width of focused window
          width_focus = 50,
          -- Width of non-focused window
          width_nofocus = 25,
        },
      })
      local ai = require("mini.ai")
      ai.setup({
        {
          n_lines = 500,
          custom_textobjects = {
            o = ai.gen_spec.treesitter({
              a = { "@block.outer", "@conditional.outer", "@loop.outer" },
              i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          },
        },
      })
    end,
  },
}
