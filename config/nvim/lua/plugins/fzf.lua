-- Fuzzy finder (fzf gets the job done, never needed telescope)
return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- Quick access
    { ";r", function() require("fzf-lua").live_grep({ hidden = true }) end, desc = "Live Grep" },
    { ";c", function() require("fzf-lua").colorschemes() end, desc = "Colorschemes" },
    { ";a", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "<leader><leader>", function() require("fzf-lua").files({ hidden = true }) end, desc = "Search Files" },
    { "\\\\", function() require("fzf-lua").resume() end, desc = "Resume Picker" },

    -- Leader + s - Search operations
    { "<leader>sh", function() require("fzf-lua").help_tags() end, desc = "Search Help" },
    { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Search Keymaps" },
    { "<leader>ss", function() require("fzf-lua").builtin() end, desc = "Search Select" },
    { "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "Search Word" },
    { "<leader>sd", function() require("fzf-lua").diagnostics_document() end, desc = "Search Diagnostics" },
    { "<leader>sD", function() require("fzf-lua").diagnostics_workspace() end, desc = "Search Diagnostics" },
    { "<leader>s.", function() require("fzf-lua").oldfiles() end, desc = "Search Recent Files" },
    { "<leader>sp", function() require("fzf-lua").files { cwd = require("lazy.core.config").options.root } end, desc = "Search Plugin Files" },
    { "<leader>sn", function() require("fzf-lua").files { cwd = vim.fn.stdpath "config" } end, desc = "Search Neovim Config" },

    -- Other
    { "<leader>/", function() require("fzf-lua").blines() end, desc = "Search Current Buffer" },
  },
  opts = {},
}  
