-- Symphony by vyrx
-- Theme: Forest
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
				base00 = "#020802",
				base01 = "#518a51",
				base02 = "#020802",
				base03 = "#518a51",
				base04 = "#bff2ab",
				base05 = "#fdfffd",
				base06 = "#fdfffd",
				base07 = "#bff2ab",
				base08 = "#bf5a7c",
				base09 = "#dcb0be",
				base0A = "#DFEC63",
				base0B = "#70cf6c",
				base0C = "#9ed8dd",
				base0D = "#62e2a4",
				base0E = "#e0eb7a",
				base0F = "#f6fdb7",
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
