-- Symphony by vyrx
-- Theme: Rose Pine
-- https://github.com/vyrx-dev

return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},
}
