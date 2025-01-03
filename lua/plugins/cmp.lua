return {
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local lsp_zero = require("lsp-zero")

      local cmp_action = lsp_zero.cmp_action()
      local cmp_format = lsp_zero.cmp_format()
      local tailwindcss_colors = require("tailwindcss-colorizer-cmp")

      local cmp_formatter = function(entry, vim_item)
        -- vim_item as processed by tailwindcss-colorizer-cmp
        vim_item = tailwindcss_colors.formatter(entry, vim_item)

        -- change menu (name of source)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          buffer = "[Buffer]",
          path = "[Path]",
          emoji = "[Emoji]",
          luasnip = "[LuaSnip]",
          vsnip = "[VSCode Snippet]",
          calc = "[Calc]",
          spell = "[Spell]",
        })[entry.source.name]

        local completion_item = entry:get_completion_item()
        local highlights_info = require("colorful-menu").highlights(completion_item, vim.bo.filetype)

        -- error, such as missing parser, fallback to use raw label.
        if highlights_info == nil then
          vim_item.abbr = completion_item.label
        else
          vim_item.abbr_hl_group = highlights_info.highlights
          vim_item.abbr = highlights_info.text
        end

        local kind = require("lspkind").cmp_format({
          mode = "symbol_text",
        })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        vim_item.kind = " " .. (strings[1] or "") .. " "
        return vim_item
      end
      opts.formatting = {
        fields = { "menu", "abbr", "kind" },
        format = cmp_formatter,
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
