return {
    {
    "glepnir/lspsaga.nvim",
    keys = {
      { "gpr", "<cmd>Lspsaga finder<CR>", "n" },
      { "<leader>lr", "<cmd>Lspsaga rename<CR>" },
      { "<leader>la", "<cmd>Lspsaga code_action<CR>", "n, v" },
      { "gpd", "<cmd>Lspsaga peek_definition<CR>" },
      { "gd", "<cmd>Lspsaga goto_definition<CR>" },
      { "gpt", "<cmd>Lspsaga peek_type_definition<CR>" },
      { "gt", "<cmd>Lspsaga goto_type_definition<CR>" },
      { "<Leader>lci", "<cmd>Lspsaga incoming_calls<CR>" },
      { "<Leader>lco", "<cmd>Lspsaga outgoing_calls<CR>" },
      { "<leader>lsd", "<cmd>Lspsaga show_line_diagnostics<CR>" },
      { "<leader>so", "<cmd>Lspsaga outline<CR>" },
      { "K", "<cmd>Lspsaga hover_doc<CR>" },
      -- { "<A-d>", "<cmd>Lspsaga term_toggle<CR>", "n, t" },
    },
    event = "LspAttach",
    ft = { "typescript", "javascript", "vue", "svelte", "markdown", "react", "json", "lua", "sh", "python" },
    config = function()
      require("lspsaga").setup({
        vim.diagnostic.config({ 
          virtual_text = false
        })
      })
    end,
  },
}