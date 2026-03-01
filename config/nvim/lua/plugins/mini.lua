return {
  { "echasnovski/mini.ai", version = "*", opts = {} },
  { "echasnovski/mini.icons", opts = {} },
  { "echasnovski/mini.pairs", opts = {} },

  -- minimal notification UI
  {
    "echasnovski/mini.notify",
    opts = {
      window = {
        winblend = 0, -- transparency
        max_width_share = 0.5,
      },
      lsp_progress = {
        enable = false, -- disable LSP progress (handled by fidget.nvim)
        duration_last = 10000,
      },
    },
  },

  -- fast surround editing
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
      },
      n_lines = 30,
    },
  },
}
