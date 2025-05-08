return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "gbprod/none-ls-luacheck.nvim",
    "gbprod/none-ls-shellcheck.nvim",
  },
  event = "BufReadPre",
  config = function()
    require("null-ls").register(require("none-ls-luacheck.diagnostics.luacheck"))
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    -- local diagnostics = null_ls.builtins.diagnostics
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local lsp_formatting = function(bufnr)
      vim.lsp.buf.format({
        filter = function(client)
          -- apply whatever logic you want (in this example, we'll only use null-ls)
          return client.name == "null-ls"
        end,
        bufnr = bufnr,
      })
    end

    null_ls.setup({
      debug = false,
      sources = {
        formatting.markdownlint,
        formatting.stylua,
        require("none-ls.formatting.eslint_d"),
        require("none-ls-shellcheck.diagnostics"),
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              lsp_formatting(bufnr)
            end,
          })
        end
      end,
    })

    require("none-ls.formatting.eslint_d").with({
      extra_args = {
        "--style",
        "{IndentWidth: 2 ,ColumnLimit: 120}",
      },
    })
  end,
}
