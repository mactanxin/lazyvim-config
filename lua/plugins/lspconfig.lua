return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    -- "mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
  },
  ---@class PluginLspOpts
  ---
  opts = function(_, opts)
    -- disable LazyVim's native LSP folding (foldmethod=expr) so nvim-ufo
    -- stays in control of folds, otherwise it fights ufo and undoes its folds
    opts.folds = { enabled = false }

    local customizations = {
      { rule = "style/*", severity = "off", fixable = true },
      { rule = "format/*", severity = "off", fixable = true },
      { rule = "*-indent", severity = "off", fixable = true },
      { rule = "*-spacing", severity = "off", fixable = true },
      { rule = "*-spaces", severity = "off", fixable = true },
      { rule = "*-order", severity = "off", fixable = true },
      { rule = "*-dangle", severity = "off", fixable = true },
      { rule = "*-newline", severity = "off", fixable = true },
      { rule = "*quotes", severity = "off", fixable = true },
      { rule = "*semi", severity = "off", fixable = true },
    }

    local eslint_filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue",
      "html",
      "markdown",
      "json",
      "jsonc",
      "yaml",
      "toml",
      "xml",
      "gql",
      "graphql",
      "astro",
      "svelte",
      "css",
      "less",
      "scss",
      "pcss",
      "postcss",
    }

    local lspconfig = require("lspconfig")

    lspconfig.eslint.setup({
      filetypes = eslint_filetypes,
      settings = {
        rulesCustomizations = customizations,
      },
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            -- 静默执行 code_action，不显示 'No actions available'
            pcall(function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return action.title:find('Fix all') or action.title:find('eslint')
                end,
                apply = true,
              })
            end)
          end,
        })
      end,
    })
    table.insert(opts.servers.vtsls.filetypes, "vue")
    LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
      {
        name = "@vue/typescript-plugin",
        location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      },
    })
  end,
}
