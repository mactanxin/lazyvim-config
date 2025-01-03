return {
  "xzbdmw/colorful-menu.nvim",
  config = function()
    -- You don't need to set these options.
    require("colorful-menu").setup({
      ft = {
        lua = {
          -- Maybe you want to dim arguments a bit.
          auguments_hl = "@comment",
        },
        typescript = {
          -- Or "vtsls", their information is different, so we
          -- need to know in advance.
          ls = "typescript-language-server",
        },
        rust = {
          -- such as (as Iterator), (use std::io).
          extra_info_hl = "@comment",
        },
        c = {
          -- such as "From <stdio.h>"
          extra_info_hl = "@comment",
        },
      },
      -- If the built-in logic fails to find a suitable highlight group,
      -- this highlight is applied to the label.
      fallback_highlight = "@variable",
      -- If provided, the plugin truncates the final displayed text to
      -- this width (measured in display cells). Any highlights that extend
      -- beyond the truncation point are ignored. Default 60.
      max_width = 60,
    })
  end,
}
