-- Preview tools
return {
  -- HTML preview
  {
    "barrett-ruth/live-server.nvim",
    build = "npm install -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },

  -- Markdown preview
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    keys = {
      {
        "<leader>pm",
        function()
          require("peek").open()
        end,
        desc = "Markdown Preview Open",
      },
      {
        "<leader>pc",
        function()
          require("peek").close()
        end,
        desc = "Markdown Preview  Close",
      },
    },
  },

  -- Markdown render
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    opts = {},
  },
}
