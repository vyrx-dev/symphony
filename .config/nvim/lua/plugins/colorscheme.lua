-- NOTE:
-- lazy = false, -- make sure we load this during startup if it is your main colorscheme
-- priority = 1000, -- make sure to load this before all the other plugins
return {
  -- Solarized Osaka
  {
    "craftzdog/solarized-osaka.nvim",
    branch = "osaka",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "wave",
    },
  },
  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_mode = true,
    },
  },
  -- Gruvbox Material
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    priority = 1000,
    opts = {},
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_transparent_background = 1
    end,
  },
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_background = true,
    },
  },
  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
    },
  },
  -- Vague
  {
    "vague2k/vague.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  -- Set the active theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vague", -- Change the Themes
    },
  },
}

-- return {
--   { "vyrx-dev/void.nvim", lazy = false, priority = 1000 },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "void",
--     },
--   },
-- }
