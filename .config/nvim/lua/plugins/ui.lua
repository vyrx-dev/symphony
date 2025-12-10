-- UI enhancements
return {
  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },

  -- focus mode (hide everything except the the file)
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

  -- code snippets images
  {
    "mistricky/codesnap.nvim",
    build = "make",
    config = function()
      require("codesnap").setup {
        watermark = "",
        save_path = "~/Pictures/CodeSnaps", -- Set a save directory
      }
    end,
  },

  -- indent line
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          {
            "j-hui/fidget.nvim",
            opts = {
              notification = {
                window = {
                  winblend = 0,
                  normal_hl = "FloatBorder",
                  override_vim_notify = false, -- let mini.notify handle vim.notify
                },
              },
            },
          },
          "Trouble",
        },
      },
    },
  },

  -- Show key presses on screen
  {
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    version = "*",
    config = function()
      require("screenkey").setup {
        win_opts = {
          width = 18,
          height = 1,
          title = "",
        },
      }
    end,
  },

  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          theme = "auto",
        },
        sections = {
          lualine_x = {
            {
              function()
                return vim.g.autoformat_enabled and "󰉼 fmt" or "󰉼 fmt"
              end,
              color = function()
                return vim.g.autoformat_enabled and { fg = "#a6e3a1" } or { fg = "#f38ba8" }
              end,
            },
            "encoding",
            "fileformat",
            "filetype",
          },
        },
      }
    end,
  },

  -- keymaps hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- lsp progress notification
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
          normal_hl = "FloatBorder",
          override_vim_notify = false, -- let mini.notify handle vim.notify
        },
      },
    },
  },

  -- better comments highlights
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Undo history
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
}
