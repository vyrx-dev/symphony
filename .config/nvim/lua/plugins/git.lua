return {
  -- git signs
  { "lewis6991/gitsigns.nvim" },

  -- for more advanced feature
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>gs", function()
        if vim.bo.filetype == "fugitive" then
          vim.cmd "q"
        else
          vim.cmd "Git"
        end
      end, { desc = "Toggle Fugitive Panel" })
    end,
  },

  -- git tui
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
  },
}
