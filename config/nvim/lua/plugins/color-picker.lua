return {
  {
    "eero-lehtinen/oklch-color-picker.nvim",
    event = "VeryLazy",
    -- version = "*", -- Pinning version is optional
    keys = {
      -- One handed keymap recommended, you will be using the mouse
      { "<leader>co", function() require("oklch-color-picker").open_picker() end, desc = "Open Color Picker" },
      { "<leader>cu", function() require("oklch-color-picker").pick_under_cursor() end, desc = "Pick Color Under Cursor" },
    },
    opts = {
      -- for example, to highlight colors in the buffer
      highlight_colors = {
        enable = true,
      },
      -- for example, to use a different keymap to confirm the color
      keymaps = {
        confirm = "<CR>",
      },
    },
  },
}
