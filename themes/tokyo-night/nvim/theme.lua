-- Symphony by vyrx
-- Theme: Tokyo Night
-- https://github.com/vyrx-dev

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
}
