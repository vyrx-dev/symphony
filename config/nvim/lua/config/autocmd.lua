-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================
local on_attach = require("utils.lsp").on_attach

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank {
      higroup = "IncSearch",
      timeout = 200,
    }
  end,
})

-- format on save using efm langserver and configured formatters
local lsp_fmt_group = vim.api.nvim_create_augroup("FormatOnSaveGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = lsp_fmt_group,
  callback = function()
    -- Check if autoformat is enabled
    if not vim.g.autoformat_enabled then
      return
    end

    local efm = vim.lsp.get_clients { name = "efm" }
    if vim.tbl_isempty(efm) then
      return
    end
    vim.lsp.buf.format { name = "efm", async = true }
  end,
})

-- Toggle autoformat command
vim.g.autoformat_enabled = true --Global toggle for autoformatting (default: enabled)
vim.api.nvim_create_user_command("ToggleAutoformat", function()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  if vim.g.autoformat_enabled then
    vim.notify("Autoformat enabled", vim.log.levels.INFO)
  else
    vim.notify("Autoformat disabled", vim.log.levels.WARN)
  end
end, {})

-- on attach function shortcuts
local lsp_on_attach_group = vim.api.nvim_create_augroup("LspMappings", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_on_attach_group,
  callback = on_attach,
})
