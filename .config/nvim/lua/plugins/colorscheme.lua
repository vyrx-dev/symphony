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
      -- transparent = true,
    },
  },
  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      -- transparent = true,
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
      -- transparent_background = true,
    },
  },
  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "night",
      -- transparent = true,
    },
  },
  -- Vague
  {
    "vague2k/vague.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      -- transparent = true,
    },
  },
  {
    "vyrx-dev/void.nvim",
    lazy = true,
    priority = 1000,
    opts = {},
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/aether.nvim",
    name = "aether",
    lazy = true,
    priority = 1000,
    opts = {
      disable_italics = false,
      colors = {
        -- Monotone shades (base00-base07)
        base00 = "#0f0f0f", -- Default background
        base01 = "#5e5959", -- Lighter background (status bars)
        base02 = "#0f0f0f", -- Selection background
        base03 = "#5e5959", -- Comments, invisibles
        base04 = "#e6caab", -- Dark foreground
        base05 = "#eadccc", -- Default foreground
        base06 = "#eadccc", -- Light foreground
        base07 = "#e6caab", -- Light background

        -- Accent colors (base08-base0F)
        base08 = "#e25d6c", -- Variables, errors, red
        base09 = "#e9838f", -- Integers, constants, orange
        base0A = "#f4bb54", -- Classes, types, yellow
        base0B = "#cea37f", -- Strings, green
        base0C = "#e8ab3b", -- Support, regex, cyan
        base0D = "#e2be8a", -- Functions, keywords, blue
        base0E = "#f66151", -- Keywords, storage, magenta
        base0F = "#edb95a", -- Deprecated, brown/yellow
      },
    },
    config = function(_, opts)
      require("aether").setup(opts)
      vim.cmd.colorscheme("aether")

      -- Enable hot reload
      -- require("aether").setup()
    end,
  },

  -- Set the active theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether", -- Change the Themes
    },
  },
}
