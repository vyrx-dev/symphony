-- ================================================================================================
-- TITLE : efm-langserver
-- ABOUT : a general purpose language server protocol implemented here for linters/formatters
-- LINKS :
--   > github : https://github.com/mattn/efm-langserver
--   > configs: https://github.com/creativenull/efmls-configs-nvim/tree/main
-- ================================================================================================

--- @param capabilities table LSP client capabilities (from nvim-cmp)
--- @return nil
return function(capabilities)
  local luacheck = require "efmls-configs.linters.luacheck" -- lua linter
  local stylua = require "efmls-configs.formatters.stylua" -- lua formatter
  local flake8 = require "efmls-configs.linters.flake8" -- python linter
  local black = require "efmls-configs.formatters.black" -- python formatter
  local go_revive = require "efmls-configs.linters.go_revive" -- go linter
  local gofumpt = require "efmls-configs.formatters.gofumpt" -- go formatter
  local prettier_d = require "efmls-configs.formatters.prettier_d" -- ts/js/solidity/json/docker/html/css/react/svelte/vue formatter
  local eslint_d = require "efmls-configs.linters.eslint_d" -- ts/js/solidity/json/react/svelte/vue linter
  local fixjson = require "efmls-configs.formatters.fixjson" -- json formatter
  local shellcheck = require "efmls-configs.linters.shellcheck" -- bash linter
  local shfmt = require "efmls-configs.formatters.shfmt" -- bash formatter
  local hadolint = require "efmls-configs.linters.hadolint" -- docker linter

  vim.lsp.config("efm", {
    capabilities = capabilities,
    filetypes = {
      "css",
      "docker",
      "go",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "python",
      "sh",
      "svelte",
      "typescript",
      "typescriptreact",
      -- "vue",
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
    settings = {
      languages = {
        css = { prettier_d },
        docker = { hadolint, prettier_d },
        go = { gofumpt, go_revive },
        html = { prettier_d },
        javascript = { eslint_d, prettier_d },
        javascriptreact = { eslint_d, prettier_d },
        json = { eslint_d, fixjson },
        jsonc = { eslint_d, fixjson },
        lua = { luacheck, stylua },
        markdown = { prettier_d },
        python = { flake8, black },
        sh = { shellcheck, shfmt },
        svelte = { eslint_d, prettier_d },
        typescript = { eslint_d, prettier_d },
        typescriptreact = { eslint_d, prettier_d },
        -- vue = { eslint_d, prettier_d },
      },
    },
  })
end
