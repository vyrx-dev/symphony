-- Symphony by vyrx
-- Theme: Sakura
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
				base00 = "#0d0509",
				base01 = "#4a3c45",
				base02 = "#0d0509",
				base03 = "#8a6a7a",
				base04 = "#E3C5AB",
				base05 = "#f0eaed",
				base06 = "#ffffff",
				base07 = "#E3C5AB",
				base08 = "#E85F6F",
				base09 = "#FF7A8A",
				base0A = "#D4A882",
				base0B = "#F29B9A",
				base0C = "#E8C099",
				base0D = "#D9A56C",
				base0E = "#D1B399",
				base0F = "#FBD2AB",
			},
		},
		config = function(_, opts)
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")
		end,
	},

	-- Alternative: pixel.nvim (extracts colors from terminal)
	-- {
	-- 	"bjarneo/pixel.nvim",
	-- 	name = "pixel",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("pixel")
	-- 	end,
	-- },
}
