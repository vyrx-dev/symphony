-- Yazi file manager
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "sf", "<cmd>Yazi<cr>", desc = "Open Yazi at current file" },
    { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
    { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session" },
  },
  opts = {
    open_for_directories = false,
    keymaps = { show_help = "<f1>" },
    yazi_floating_window_border = "none",
  },
}
