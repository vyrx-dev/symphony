-- Fuzzy finder (fzf gets the job done, never needed telescope)
return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- Quick access
    { ";r", function() require("fzf-lua").live_grep({ rg_opts = "--hidden -g '!.git'" }) end, desc = "Live Grep" },
    { ";f", function() require("fzf-lua").files({ fd_opts = "--hidden --exclude .git" }) end, desc = "Search Files" },
    { ";c", function() require("fzf-lua").colorschemes() end, desc = "Colorschemes" },
    { ";;", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "\\\\", function() require("fzf-lua").resume() end, desc = "Resume Picker" },

    -- Leader + f - Find operations
    { "<leader>fi", function() require("fzf-lua").lsp_incoming_calls() end, desc = "LSP Incoming Calls" },
    { "<leader>fx", function() require("fzf-lua").diagnostics_document() end, desc = "Diagnostics Document" },
    { "<leader>fX", function() require("fzf-lua").diagnostics_workspace() end, desc = "Diagnostics Workspace" },
    { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "LSP Document Symbols" },
    { "<leader>fS", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- Leader + s - Search operations
    { "<leader>sh", function() require("fzf-lua").help_tags() end, desc = "Search Help" },
    { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Search Keymaps" },
    { "<leader>sf", function() require("fzf-lua").files() end, desc = "Search Files" },
    { "<leader>ss", function() require("fzf-lua").builtin() end, desc = "Search Select" },
    { "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "Search Word" },
    { "<leader>sd", function() require("fzf-lua").diagnostics_document() end, desc = "Search Diagnostics" },
    { "<leader>s.", function() require("fzf-lua").oldfiles() end, desc = "Search Recent Files" },
    { "<leader>sp", function() require("fzf-lua").files { cwd = require("lazy.core.config").options.root } end, desc = "Search Plugin Files" },
    { "<leader>sn", function() require("fzf-lua").files { cwd = vim.fn.stdpath "config" } end, desc = "Search Neovim Config" },

    -- Other
    { "<leader>/", function() require("fzf-lua").blines() end, desc = "Search Current Buffer" },
  },
  opts = {},
}
