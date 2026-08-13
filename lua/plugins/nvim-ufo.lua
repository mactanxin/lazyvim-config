-- TypeScript type-level declarations (treesitter node types) mapped to fold kinds.
-- The LSP reports these ranges without a `kind`, so they can't be closed via
-- `close_fold_kinds_for_ft` unless we tag them ourselves.
local ts_type_kinds = {
  interface_declaration = "interface",
  type_alias_declaration = "type",
  enum_declaration = "enum",
}

---Merged fold provider for TypeScript/TSX: keeps the LSP fold ranges (so
---`imports`/`comment` kinds keep working) and tags type-level declaration
---ranges with a kind, allowing them to be auto-closed. Brace-less declarations
---(e.g. `type X = ...`) have no LSP fold range, so those are added from the
---treesitter query results directly.
---@param bufnr number
local function ts_fold_provider(bufnr)
  local lsp = require("ufo.provider.lsp")
  local treesitter = require("ufo.provider.treesitter")
  return lsp.getFolds(bufnr):thenCall(function(ranges)
    local ok, ts_ranges = pcall(treesitter.getFolds, bufnr)
    if not ok or not ts_ranges or #ts_ranges == 0 then
      return ranges
    end
    for _, ts_range in ipairs(ts_ranges) do
      local kind = ts_type_kinds[ts_range.kind]
      if kind then
        local tagged = false
        for _, range in ipairs(ranges) do
          if not range.kind and range.startLine == ts_range.startLine then
            range.kind = kind
            tagged = true
            break
          end
        end
        if not tagged then
          table.insert(ranges, {
            startLine = ts_range.startLine,
            endLine = ts_range.endLine,
            kind = kind,
          })
        end
      end
    end
    require("ufo.model.foldingrange").sortRanges(ranges)
    return ranges
  end)
end

---Fallback wrapper: ufo invokes the fallback provider synchronously and does not
---catch a throw (e.g. nofile buffers, missing treesitter parser), which surfaces
---as an unhandled promise rejection. Return nil instead so no folds are applied.
---@param bufnr number
local function safe_treesitter(bufnr)
  local ok, res = pcall(require("ufo.provider.treesitter").getFolds, bufnr)
  return ok and res or nil
end

return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  -- load before the buffer is displayed so ufo attaches on the first BufWinEnter;
  -- VeryLazy is too late and misses already-open buffers
  event = "BufReadPost",
  opts = {
    -- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
    open_fold_hl_timeout = 400,
    close_fold_kinds_for_ft = {
      description = [[After the buffer is displayed (opened for the first time), close the
                    folds whose range with `kind` field is included in this option. For now,
                    'lsp' provider's standardized kinds are 'comment', 'imports' and 'region'.
                    This option is a table with filetype as key and fold kinds as value. Use a
                    default value if value of filetype is absent.
                    Run `UfoInspect` for details if your provider has extended the kinds.]],
      default = {
        "imports",
        "comment",
      },
      -- extra kinds tagged by the merged TS provider below
      typescript = { "imports", "comment", "interface", "type", "enum" },
      typescriptreact = { "imports", "comment", "interface", "type", "enum" },
    },

    provider_selector = function(bufnr, filetype, buftype)
      -- nofile buffers (dashboard, scratch, ...) are rejected by both ufo
      -- providers, so don't request folds for them at all
      if buftype == "nofile" then
        return ""
      end
      if filetype == "typescript" or filetype == "typescriptreact" then
        return { ts_fold_provider, safe_treesitter }
      end
      return { "lsp", safe_treesitter } -- Uses LSP folds with Treesitter fallback
    end,
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        -- winhighlight = "Normal:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
  },
  init = function()
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  config = function(_, opts)
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local totalLines = vim.api.nvim_buf_line_count(0)
      local foldedLines = endLnum - lnum
      local suffix = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
      suffix = (" "):rep(rAlignAppndx) .. suffix
      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end
    opts["fold_virt_text_handler"] = handler
    require("ufo").setup(opts)
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- vim.lsp.buf.hover()
        vim.cmd([[ Lspsaga hover_doc ]])
      end
    end)
  end,
}
