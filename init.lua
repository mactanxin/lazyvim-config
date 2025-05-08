-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = true,
    })
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "none", nocombine = true })
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { bg = "none", nocombine = true })
  end,
})
