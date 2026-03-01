-- ================================================================================================
-- TITLE : gopls (Golang Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/golang/tools/tree/master/gopls
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
  vim.lsp.config("gopls", {
    capabilities = capabilities,
    filetypes = { "go" },
  })
end
