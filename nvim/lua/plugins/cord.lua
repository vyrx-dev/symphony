return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy",
  opts = {
    editor = {
      client = "neovim",
      tooltip = "Editing with ⚡Neovim",
    },
    display = {
      theme = "default",
      flavor = "dark",
    },
    timestamp = { enabled = true },
    idle = {
      enabled = true,
      timeout = 300000, -- 5 minutes
      details = "Idle ☕",
      state = "Taking a break",
    },
    text = {
      workspace = "In project ${workspace}",
      editing = "Editing ${filename}",
      file_browser = "Browsing ${name}",
      plugin_manager = "Managing plugins",
    },
    variables = true,
  },
}
