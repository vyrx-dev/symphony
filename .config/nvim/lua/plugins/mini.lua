return {
  -- Text objects
  { "echasnovski/mini.ai", version = "*", opts = {} },

  -- icons provider
  { "echasnovski/mini.icons", opts = {} },

  -- auto pairs for brackets/quotes
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

  -- better file explorer than oil (facts 🙂)
  {
    "echasnovski/mini.files",
    version = false,
    config = function()
      require("mini.files").setup()
      vim.keymap.set("n", "sf", function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0))
      end, { desc = "Open mini.files" })
    end,
  },
}
