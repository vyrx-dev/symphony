-- ================================================================================================
-- TITLE : tailwindcss LSP Setup
-- LINKS :
--   > github: https://github.com/tailwindlabs/tailwindcss-intellisense
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
	vim.lsp.config('tailwindcss', {
		capabilities = capabilities,
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
	})
end
