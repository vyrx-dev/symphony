return {
  -- Auto-install LSPs, formatters, linters via Mason on startup
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-tool-installer").setup {
        ensure_installed = {
          -- LSP Servers
          "bash-language-server",
          "docker-language-server",
          "emmet-ls",
          "gopls",
          "lua-language-server",
          "pyright",
          "typescript-language-server",
          "json-lsp",
          "yaml-language-server",
          "tailwindcss-language-server",
          "efm",

          -- Formatters
          "prettierd",
          "stylua",
          "gofumpt",
          "shfmt",
          "fixjson",

          -- Linters
          "eslint_d",
          "flake8",
          "luacheck",
          "hadolint",
          "shellcheck",
          "revive",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 sec delay to avoid blocking startup
      }
    end,
  },

  -- Core LSP configurations and server setups
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim", -- LSP/DAP/Linter installer & manager
      "creativenull/efmls-configs-nvim", -- Preconfigured EFM Language Server setups
      "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for LSP-based completion
    },
    config = function()
      require("utils.diagnostics").setup()
      require "servers"
    end,
  },

  -- Better UI for LSP actions (hover, rename, diagnostics, etc.)
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("lspsaga").setup {
        move_in_saga = { prev = "<C-k>", next = "<C-j>" },
        finder_action_keys = {
          open = "<CR>",
        },
        definition_action_keys = {
          edit = "<CR>",
        },
        symbol_in_winbar = {
          enable = false,
        },
      }
    end,
  },
}
