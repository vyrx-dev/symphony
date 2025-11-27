return{
  -- zen-mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        options = {
          laststatus = 0,
        },
        tmux = true,
        kitty = { enabled = false, font = "+4" },
        alacritty = { enabled = true, font = "18" },
      },
   },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({})
	end,
	priority = 1000,

-- statusline
    {
      'nvim-lualine/lualine.nvim',
      config = function ()
    require('lualine').setup({
      options = {
      theme = 'auto'
    }
})
   end
  },
 {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Fugitive Panel" })
    end,
  },
{
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
 {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
{
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      triggers = {
        { "<auto>", mode = "nxso" },
      },
    },
  },
{ "debugloop/telescope-undo.nvim", event = "VeryLazy" },
{ "nanotee/zoxide.vim", event = "VeryLazy" },
 {
    "mbbill/undotree",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Telescope Undo" })
    end,
  },
}
