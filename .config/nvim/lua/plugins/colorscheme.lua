return {
  { "savq/melange-nvim", lazy = true },
  { "AlexvZyl/nordic.nvim", lazy = true },
  { "xero/miasma.nvim", lazy = true },
  { "tiagovla/tokyodark.nvim", lazy = true, opts = { transparent_background = true } },
  { "rebelot/kanagawa.nvim", lazy = true, opts = { transparent = false, theme = "wave" } },
  { "ellisonleao/gruvbox.nvim", lazy = true, opts = { transparent_mode = true } },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { transparent_background = false, flavour = "mocha" } },
  { "folke/tokyonight.nvim", lazy = true, opts = { style = "night", transparent = true } },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = { styles = { transparency = false } },
  },
  -- superior gruvbox variant
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_transparent_background = 1
    end,
  },
  -- custom theme
  {
    "bjarneo/aether.nvim",
    name = "aether",
    lazy = true,
    opts = {
      disable_italics = false,
      transparent = true,
      colors = {
        -- aamis
        --   base00 = "#0f0f0f",
        --   base01 = "#5e5959",
        --   base02 = "#0f0f0f",
        --   base03 = "#5e5959",
        --   base04 = "#e6caab",
        --   base05 = "#eadccc",
        --   base06 = "#eadccc",
        --   base07 = "#e6caab",
        --   base08 = "#e25d6c",
        --   base09 = "#e9838f",
        --   base0A = "#f4bb54",
        --   base0B = "#cea37f",
        --   base0C = "#e8ab3b",
        --   base0D = "#e2be8a",
        --   base0E = "#f66151",
        --   base0F = "#edb95a",

        -- sakura
        base00 = "#0d0509",
        base01 = "#4a3c45",
        base02 = "#0d0509",
        base03 = "#8a6a7a",
        base04 = "#E3C5AB",
        base05 = "#f0eaed",
        base06 = "#ffffff",
        base07 = "#E3C5AB",
        base08 = "#E85F6F",
        base09 = "#FF7A8A",
        base0A = "#D4A882",
        base0B = "#F29B9A",
        base0C = "#E8C099",
        base0D = "#D9A56C",
        base0E = "#D1B399",
        base0F = "#FBD2AB",

        -- forest
        -- base00 = "#020802",
        -- base01 = "#518a51",
        -- base02 = "#020802",
        -- base03 = "#518a51",
        -- base04 = "#bff2ab",
        -- base05 = "#fdfffd",
        -- base06 = "#fdfffd",
        -- base07 = "#bff2ab",
        -- base08 = "#bf5a7c",
        -- base09 = "#dcb0be",
        -- base0A = "#DFEC63",
        -- base0B = "#70cf6c",
        -- base0C = "#9ed8dd",
        -- base0D = "#62e2a4",
        -- base0E = "#e0eb7a",
        -- base0F = "#f6fdb7",
      },
    },
  },
  -- fav theme (only this will be loaded on startup)
  {
    "vague2k/vague.nvim",
    priority = 1000,
    lazy = false,
    opts = { transparent = true },
    config = function(_, opts)
      require("vague").setup(opts)
      vim.cmd.colorscheme "vague"
    end,
  },
}
