return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "mikavilpas/blink-ripgrep.nvim",
    "giuxtaposition/blink-cmp-copilot",
  },
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      keymap = {
        -- 选择并接受预选择的第一个
        ["<CR>"] = { "select_and_accept", "fallback" },
      },
      completion = {
        -- 自动显示补全窗口
        menu = { auto_show = true },
        -- 不在当前行上显示所选项目的预览
        ghost_text = { enabled = false },
      },
    },
    keymap = {
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      -- fallback命令将运行下一个非闪烁键盘映射(回车键的默认换行等操作需要)
      ["<CR>"] = { "accept", "fallback" }, -- 更改成'select_and_accept'会选择第一项插入
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" }, -- 同时存在补全列表和snippet时，补全列表选择优先级更高

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-e>"] = { "snippet_forward", "select_next", "fallback" }, -- 同时存在补全列表和snippet时，snippet跳转优先级更高
      ["<C-u>"] = { "snippet_backward", "select_prev", "fallback" },
    },
    completion = {
      -- 示例：使用'prefix'对于'foo_|_bar'单词将匹配'foo_'(光标前面的部分),使用'full'将匹配'foo__bar'(整个单词)
      keyword = { range = "full" },
      -- 选择补全项目时显示文档(0.5秒延迟)
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      -- 不预选第一个项目，选中后自动插入该项目文本
      list = { selection = { preselect = false, auto_insert = true } },
      menu = {
        draw = {
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
          components = {
            label = {
              text = function(ctx)
                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                if highlights_info ~= nil then
                  -- Or you want to add more item to label
                  return highlights_info.label
                else
                  return ctx.label
                end
              end,
              highlight = function(ctx)
                local highlights = {}
                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                if highlights_info ~= nil then
                  highlights = highlights_info.highlights
                end
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                end
                -- Do something else
                return highlights
              end,
            },
          },
        },
      },
    },

    -- 指定文件类型启用/禁用
    enabled = function()
      return not vim.tbl_contains({
        -- "lua",
        -- "markdown"
      }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
    end,

    appearance = {
      -- 将后备高亮组设置为 nvim-cmp 的高亮组
      -- 当您的主题不支持blink.cmp 时很有用
      -- 将在未来版本中删除
      use_nvim_cmp_as_default = true,
      -- 将“Nerd Font Mono”设置为“mono”，将“Nerd Font”设置为“normal”
      -- 调整间距以确保图标对齐
      nerd_font_variant = "mono",
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",

        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",

        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",

        Keyword = "󰻾",
        Constant = "󰏿",

        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    },

    -- 已定义启用的提供程序的默认列表，以便您可以扩展它
    sources = {
      default = {
        "copilot",
        "lsp",
        "path",
        "buffer",
        "snippets",
        -- "ripgrep",
      },
      providers = {
        -- score_offset设置优先级数字越大优先级越高
        buffer = { score_offset = 5 },
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          score_offset = 4,
        },
        path = { score_offset = 3 },
        lsp = { score_offset = 2 },
        -- snippets = { score_offset = 1 },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
      },
    },
  },
  -- 由于“opts_extend”，您的配置中的其他位置无需重新定义它
  opts_extend = { "sources.default" },
}
