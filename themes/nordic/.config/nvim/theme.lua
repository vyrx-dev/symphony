return {
	{
		"andersevenrud/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").colorscheme({
				underline_option = "none",
				italic = true,
				italic_comments = false,
				minimal_mode = false,
				alternate_backgrounds = false,
			})
		end,
	},
}
