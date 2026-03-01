-- ================================================================================================
-- TITLE : emmet_ls (Emmet Language Server) LSP Setup
-- ABOUT : Configures Emmet Language Server for web-related (e.g. TS/JS, CSS, Sass, Svelte, Vue)
-- LINKS :
--   > github: https://github.com/aca/emmet-ls
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config('emmet_ls', {
		capabilities = capabilities,
		filetypes = {
			"html",
			"typescript",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"css",
			"sass",
			"scss",
			"svelte",
			"vue",
		},
	})
end
