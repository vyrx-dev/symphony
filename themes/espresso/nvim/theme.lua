-- Symphony by vyrx
-- Theme: Espresso
-- https://github.com/vyrx-dev

return {
	{
		"bjarneo/aether.nvim",
		name = "aether",
		lazy = false,
		priority = 1000,
		opts = {
			disable_italics = false,
			colors = {
				base00 = "#1a1513",
				base01 = "#2e2520",
				base02 = "#3a322c",
				base03 = "#5c534a",
				base04 = "#e8b89a",
				base05 = "#f0e4dc",
				base06 = "#f0e4dc",
				base07 = "#e8b89a",
				base08 = "#e8a090",
				base09 = "#d8a078",
				base0A = "#e8c8a0",
				base0B = "#c8b888",
				base0C = "#b8b098",
				base0D = "#c8a898",
				base0E = "#d8a8a0",
				base0F = "#f0b8a8",
			},
		},
		config = function(_, opts)
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")
		end,
	},
}
