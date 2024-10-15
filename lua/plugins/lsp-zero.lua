return {
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      -- LSP Support
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Autocompletion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind-nvim",
    },
    config = function()
      local lsp = require("lsp-zero")
      local mason_registry = require("mason-registry")
      local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"
      local lspconfig = require("lspconfig")
      lspconfig.vtsls.setup({
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        settings = {
          vtsls = { tsserver = { globalPlugins = {} } },
        },
        before_init = function(params, config)
          local result = vim
            .system({ "npm", "query", "#vue" }, { cwd = params.workspaceFolders[1].name, text = true })
            :wait()
          if result.stdout ~= "[]" then
            local vuePluginConfig = {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path .. "/node_modules/@vue/language-server",
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            }
            table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
          end
        end,
      })

      lspconfig.volar.setup({})

      -- setup for tailwind
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.colorProvider = { dynamicRegistration = false }
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local on_attach = function(client, bufnr)
        if client.server_capabilities.colorProvider then
          require("config.lsp.utils.documentcolors").buf_attach(bufnr)
          require("colorizer").attach_to_buffer(
            bufnr,
            { mode = "background", css = true, names = false, tailwind = false }
          )
        end
      end

      lspconfig.tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "css", "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      })
      lsp.on_attach(function(client, bufnr)
        if client.name == "tailwindcss" then
          require("tailwindcss-colors").buf_attach(bufnr)
        end
      end)
      lsp.setup()
    end,
  },
}
