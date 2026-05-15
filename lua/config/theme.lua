local M = {}
local monitor

function M.detect_system_background()
  if vim.fn.has("mac") == 1 and vim.fn.executable("defaults") == 1 then
    local output = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
    if vim.v.shell_error == 0 and output:match("Dark") then
      return "dark"
    end
    return "light"
  end

  return vim.o.background
end

function M.sync_background()
  local background = M.detect_system_background()
  if vim.o.background ~= background then
    vim.o.background = background
    return true
  end

  return false
end

function M.apply_catppuccin()
  if vim.g.colors_name == "catppuccin" then
    vim.cmd("colorscheme catppuccin")
  end
end

function M.refresh()
  if M.sync_background() then
    M.apply_catppuccin()
  end
end

function M.start_monitor(interval_ms)
  if monitor then
    return
  end

  local uv = vim.uv or vim.loop
  local timer = uv.new_timer()
  if not timer then
    return
  end

  monitor = timer
  timer:start(
    interval_ms or 2000,
    interval_ms or 2000,
    vim.schedule_wrap(function()
      M.refresh()
    end)
  )
end

function M.stop_monitor()
  if not monitor then
    return
  end

  monitor:stop()
  monitor:close()
  monitor = nil
end

return M
