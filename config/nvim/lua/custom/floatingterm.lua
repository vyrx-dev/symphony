local state = {
  buf = nil,
  win = nil,
}

local function create_float_terminal()
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf_valid = state.buf and vim.api.nvim_buf_is_valid(state.buf)
  local win_valid = state.win and vim.api.nvim_win_is_valid(state.win)

  if win_valid then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  if not buf_valid then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = "Terminal",
    title_pos = "center",
  })

  vim.api.nvim_set_option_value("winblend", 0, { win = state.win })
  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,FloatBorder:FloatBorder", { win = state.win })

  if not buf_valid then
    vim.cmd.terminal()
  end

  vim.cmd.startinsert()
end

local function delete_float_terminal()
  local buf_valid = state.buf and vim.api.nvim_buf_is_valid(state.buf)
  local win_valid = state.win and vim.api.nvim_win_is_valid(state.win)

  if win_valid then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end

  if buf_valid then
    vim.api.nvim_buf_delete(state.buf, { force = true })
    state.buf = nil
    print "Terminal buffer deleted"
  else
    print "No Buffer to delete"
  end
end

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })
vim.keymap.set({ "n", "t" }, ";t", create_float_terminal, { desc = "Toggle Floating Terminal" })
vim.keymap.set({ "n", "t" }, ";d", delete_float_terminal, { desc = "delete float terminal" })
