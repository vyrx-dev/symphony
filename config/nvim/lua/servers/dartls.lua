-- ================================================================================================
-- TITLE : dartls
-- ABOUT : Dart language server (ships with Dart SDK, used for Flutter development)
-- LINKS :
--   > dart lsp : https://github.com/dart-lang/sdk/tree/main/pkg/analysis_server
--   > flutter  : https://flutter.dev
-- ================================================================================================

--- @param capabilities table LSP client capabilities (from nvim-cmp)
--- @return nil
return function(capabilities)
  local dartExcludedFolders = {
    vim.fn.expand "$HOME/.pub-cache",
    vim.fn.expand "$HOME/dev-tools/flutter/",
  }

  vim.lsp.config("dartls", {
    capabilities = capabilities,
    cmd = {
      "dart",
      "language-server",
      "--protocol=lsp",
    },
    filetypes = { "dart" },
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = false,
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
      outline = false,
      flutterOutline = false,
    },
    settings = {
      dart = {
        analysisExcludedFolders = dartExcludedFolders,
        updateImportsOnRename = true,
        completeFunctionCalls = true,
        showTodos = true,
      },
    },
  })
end
