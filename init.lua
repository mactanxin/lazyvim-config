-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local theme = require("config.theme")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if #vim.api.nvim_list_uis() > 0 then
      theme.start_monitor(2000)
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  callback = function()
    vim.schedule(function()
      theme.refresh()
    end)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    theme.stop_monitor()
  end,
})

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
