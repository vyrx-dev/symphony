-- Symphony by vyrx
-- Theme: Espresso
-- https://github.com/vyrx-dev
-- Cohesive warm espresso aesthetic

local M = {}

M.colors = {
	-- Base colors
	bg = "#1a1513",
	bg_dim = "#2e2520",
	bg_highlight = "#3a322c",
	bg_visual = "#4a423c",
	fg = "#f0e4dc",
	fg_dim = "#d8ccc0",
	comment = "#5c534a",

	-- ANSI colors (cohesive warm espresso palette)
	black = "#2e2520",
	red = "#e8a090",
	green = "#c8b888",
	yellow = "#e8c8a0",
	blue = "#c8a898",
	magenta = "#d8a8a0",
	cyan = "#b8b098",
	white = "#d8ccc0",

	-- Bright ANSI
	bright_black = "#5c534a",
	bright_red = "#f0b8a8",
	bright_green = "#d8c8a0",
	bright_yellow = "#f0d8b8",
	bright_blue = "#d8b8a8",
	bright_magenta = "#e8b8b0",
	bright_cyan = "#c8c0a8",
	bright_white = "#f0e4dc",

	-- Special
	orange = "#d8a078",
	primary = "#e8b89a",
	cursor = "#e8b89a",
	border = "#e8b89a",
}

function M.setup()
	local colors = M.colors

	-- Reset highlighting
	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.termguicolors = true
	vim.g.colors_name = "espresso"

	-- Define highlight groups
	local highlights = {
		-- UI Elements
		Normal = { fg = colors.fg, bg = colors.bg },
		NormalFloat = { fg = colors.fg, bg = colors.bg_dim },
		FloatBorder = { fg = colors.border, bg = colors.bg_dim },
		Cursor = { fg = colors.bg, bg = colors.cursor },
		CursorLine = { bg = colors.bg_highlight },
		CursorColumn = { bg = colors.bg_highlight },
		ColorColumn = { bg = colors.bg_highlight },
		LineNr = { fg = colors.comment },
		CursorLineNr = { fg = colors.primary, bold = true },
		SignColumn = { fg = colors.comment, bg = colors.bg },
		VertSplit = { fg = colors.black },
		WinSeparator = { fg = colors.black },
		Folded = { fg = colors.comment, bg = colors.bg_dim },
		FoldColumn = { fg = colors.comment, bg = colors.bg },
		StatusLine = { fg = colors.fg, bg = colors.bg_dim },
		StatusLineNC = { fg = colors.fg_dim, bg = colors.bg_dim },
		TabLine = { fg = colors.fg_dim, bg = colors.bg_dim },
		TabLineFill = { bg = colors.bg },
		TabLineSel = { fg = colors.bg, bg = colors.primary },
		Pmenu = { fg = colors.fg, bg = colors.bg_dim },
		PmenuSel = { fg = colors.bg, bg = colors.primary },
		PmenuSbar = { bg = colors.bg_highlight },
		PmenuThumb = { bg = colors.primary },
		Visual = { bg = colors.bg_visual },
		VisualNOS = { bg = colors.bg_visual },
		Search = { fg = colors.bg, bg = colors.bright_yellow },
		IncSearch = { fg = colors.bg, bg = colors.primary },
		MatchParen = { fg = colors.primary, bold = true, underline = true },
		NonText = { fg = colors.black },
		SpecialKey = { fg = colors.black },
		Whitespace = { fg = colors.black },
		EndOfBuffer = { fg = colors.bg },
		Directory = { fg = colors.primary },
		Title = { fg = colors.primary, bold = true },
		ErrorMsg = { fg = colors.red },
		WarningMsg = { fg = colors.orange },
		MoreMsg = { fg = colors.green },
		ModeMsg = { fg = colors.fg, bold = true },
		Question = { fg = colors.green },
		WildMenu = { fg = colors.bg, bg = colors.primary },

		-- Syntax highlighting
		Comment = { fg = colors.comment, italic = true },
		Constant = { fg = colors.magenta },
		String = { fg = colors.green },
		Character = { fg = colors.green },
		Number = { fg = colors.magenta },
		Boolean = { fg = colors.magenta },
		Float = { fg = colors.magenta },
		Identifier = { fg = colors.fg },
		Function = { fg = colors.primary },
		Statement = { fg = colors.red },
		Conditional = { fg = colors.red },
		Repeat = { fg = colors.red },
		Label = { fg = colors.red },
		Operator = { fg = colors.fg },
		Keyword = { fg = colors.red },
		Exception = { fg = colors.red },
		PreProc = { fg = colors.orange },
		Include = { fg = colors.orange },
		Define = { fg = colors.orange },
		Macro = { fg = colors.orange },
		PreCondit = { fg = colors.orange },
		Type = { fg = colors.primary },
		StorageClass = { fg = colors.primary },
		Structure = { fg = colors.primary },
		Typedef = { fg = colors.primary },
		Special = { fg = colors.orange },
		SpecialChar = { fg = colors.orange },
		Tag = { fg = colors.cyan },
		Delimiter = { fg = colors.fg_dim },
		SpecialComment = { fg = colors.comment, bold = true },
		Debug = { fg = colors.red },
		Underlined = { underline = true },
		Ignore = { fg = colors.comment },
		Error = { fg = colors.red, bold = true },
		Todo = { fg = colors.bg, bg = colors.primary, bold = true },

		-- Treesitter
		["@variable"] = { fg = colors.fg },
		["@variable.builtin"] = { fg = colors.red },
		["@variable.parameter"] = { fg = colors.fg },
		["@variable.member"] = { fg = colors.cyan },
		["@constant"] = { fg = colors.magenta },
		["@constant.builtin"] = { fg = colors.magenta },
		["@constant.macro"] = { fg = colors.orange },
		["@module"] = { fg = colors.primary },
		["@label"] = { fg = colors.red },
		["@string"] = { fg = colors.green },
		["@string.escape"] = { fg = colors.orange },
		["@string.special"] = { fg = colors.orange },
		["@character"] = { fg = colors.green },
		["@number"] = { fg = colors.magenta },
		["@boolean"] = { fg = colors.magenta },
		["@float"] = { fg = colors.magenta },
		["@function"] = { fg = colors.primary },
		["@function.builtin"] = { fg = colors.primary },
		["@function.call"] = { fg = colors.primary },
		["@function.macro"] = { fg = colors.orange },
		["@function.method"] = { fg = colors.primary },
		["@function.method.call"] = { fg = colors.primary },
		["@constructor"] = { fg = colors.primary },
		["@keyword"] = { fg = colors.red },
		["@keyword.function"] = { fg = colors.red },
		["@keyword.operator"] = { fg = colors.red },
		["@keyword.return"] = { fg = colors.red },
		["@keyword.conditional"] = { fg = colors.red },
		["@keyword.repeat"] = { fg = colors.red },
		["@keyword.import"] = { fg = colors.orange },
		["@keyword.exception"] = { fg = colors.red },
		["@type"] = { fg = colors.primary },
		["@type.builtin"] = { fg = colors.primary },
		["@type.definition"] = { fg = colors.primary },
		["@type.qualifier"] = { fg = colors.red },
		["@attribute"] = { fg = colors.orange },
		["@property"] = { fg = colors.cyan },
		["@comment"] = { fg = colors.comment, italic = true },
		["@punctuation"] = { fg = colors.fg_dim },
		["@punctuation.bracket"] = { fg = colors.fg_dim },
		["@punctuation.delimiter"] = { fg = colors.fg_dim },
		["@punctuation.special"] = { fg = colors.orange },
		["@tag"] = { fg = colors.red },
		["@tag.attribute"] = { fg = colors.primary },
		["@tag.delimiter"] = { fg = colors.fg_dim },
		["@markup.heading"] = { fg = colors.primary, bold = true },
		["@markup.strong"] = { bold = true },
		["@markup.italic"] = { italic = true },
		["@markup.link"] = { fg = colors.cyan },
		["@markup.link.url"] = { fg = colors.cyan, underline = true },
		["@markup.raw"] = { fg = colors.green },
		["@diff.plus"] = { fg = colors.green },
		["@diff.minus"] = { fg = colors.red },
		["@diff.delta"] = { fg = colors.primary },

		-- LSP
		DiagnosticError = { fg = colors.red },
		DiagnosticWarn = { fg = colors.orange },
		DiagnosticInfo = { fg = colors.blue },
		DiagnosticHint = { fg = colors.green },
		DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
		DiagnosticUnderlineWarn = { undercurl = true, sp = colors.orange },
		DiagnosticUnderlineInfo = { undercurl = true, sp = colors.blue },
		DiagnosticUnderlineHint = { undercurl = true, sp = colors.green },
		LspReferenceText = { bg = colors.bg_highlight },
		LspReferenceRead = { bg = colors.bg_highlight },
		LspReferenceWrite = { bg = colors.bg_highlight },

		-- Git
		GitSignsAdd = { fg = colors.green },
		GitSignsChange = { fg = colors.primary },
		GitSignsDelete = { fg = colors.red },
		DiffAdd = { bg = "#252a20" },
		DiffChange = { bg = "#2a2518" },
		DiffDelete = { bg = "#2a201c" },
		DiffText = { bg = "#35301c" },

		-- Telescope
		TelescopeBorder = { fg = colors.border },
		TelescopePromptBorder = { fg = colors.border },
		TelescopeResultsBorder = { fg = colors.border },
		TelescopePreviewBorder = { fg = colors.border },
		TelescopeSelection = { bg = colors.bg_highlight },
		TelescopeSelectionCaret = { fg = colors.primary },
		TelescopeMatching = { fg = colors.primary, bold = true },

		-- Mini.nvim icons
		MiniIconsGrey = { fg = colors.comment },
		MiniIconsRed = { fg = colors.red },
		MiniIconsBlue = { fg = colors.blue },
		MiniIconsGreen = { fg = colors.green },
		MiniIconsYellow = { fg = colors.yellow },
		MiniIconsOrange = { fg = colors.orange },
		MiniIconsPurple = { fg = colors.magenta },
		MiniIconsAzure = { fg = colors.blue },
		MiniIconsCyan = { fg = colors.cyan },

		-- Indent Blankline
		IblIndent = { fg = colors.black },
		IblScope = { fg = colors.primary },

		-- Which-key
		WhichKey = { fg = colors.primary },
		WhichKeyGroup = { fg = colors.cyan },
		WhichKeySeparator = { fg = colors.comment },
		WhichKeyDesc = { fg = colors.fg },

		-- Lazy.nvim
		LazyButton = { fg = colors.fg, bg = colors.bg_dim },
		LazyButtonActive = { fg = colors.bg, bg = colors.primary },
		LazyH1 = { fg = colors.bg, bg = colors.primary, bold = true },
	}

	-- Apply highlights
	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

return M
