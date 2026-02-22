return {
  { "ellisonleao/gruvbox.nvim", lazy = true, opts = { transparent_mode = true } },
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
