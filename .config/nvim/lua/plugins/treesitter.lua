-- Syntax highlighting
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  lazy = false,
  config = function()
    require("nvim-treesitter.config").setup {
      -- language parsers that MUST be installed
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "typescript",
        "vue",
        "yaml",
      },
      auto_install = true, -- auto-install any other parsers on opening new language files
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        -- keymaps = {
        -- 	init_selection = "<CR>",
        -- 	node_incremental = "<CR>",
        -- 	scope_incremental = "<TAB>",
        -- 	node_decremental = "<S-TAB>",
        -- },
      },
    }
  end,
}
