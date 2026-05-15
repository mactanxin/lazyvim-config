return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        enabled = false,
      })

      return opts
    end,
  },
}
