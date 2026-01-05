-- Aetheria Theme for Neovim
-- Inspired by Audio Waveform Omarchy colorscheme and Base16-Tarot color palette

return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = function()
                -- Dark color palette
                local colors = {
                    -- Base colors (dark theme)
                    hex_0e091d = '#0e091d', -- Very dark blue-purple
                    hex_061F23 = '#061F23', -- Very dark teal-blue
                    hex_092F34 = '#092F34', -- Dark desaturated blue
                    hex_0C3F45 = '#0C3F45', -- Dark muted blue-green
                    hex_0F5057 = '#0F5057', -- Dark teal-blue
                    hex_126069 = '#126069', -- Dark desaturated blue-green

                    -- Foreground colors
                    hex_C8E967 = '#C8E967', -- Bright yellowish-green
                    hex_A8D61F = '#A8D61F', -- Bright yellow-green
                    hex_8CB319 = '#8CB319', -- Muted yellow-green

                    -- Accent colors (aetheria neon palette)
                    hex_9147a8 = '#9147a8', -- Dark purple
                    hex_E20342 = '#E20342', -- Bright red
                    hex_FF7F41 = '#FF7F41', -- Bright orange
                    hex_04C5F0 = '#04C5F0', -- Bright cyan-blue
                    hex_f93d3b = '#f93d3b', -- Vibrant red
                    hex_ffbe74 = '#ffbe74', -- Light orange-yellow
                    hex_FD3E6A = '#FD3E6A', -- Vibrant pink-red
                    hex_7cd699 = '#7cd699', -- Light blue-green
                    hex_47A854 = '#47A854', -- Dark green
                }
                ---@diagnostic disable: undefined-global
                -- Reset highlighting
                vim.cmd('highlight clear')
                if vim.fn.exists('syntax_on') then
                    vim.cmd('syntax reset')
                end

                vim.o.termguicolors = true
                vim.o.background = 'dark'
                vim.g.colors_name = 'aetheria'

                local hl = vim.api.nvim_set_hl

                -- Editor highlights
                hl(0, 'Normal', { fg = colors.hex_C8E967, bg = colors.hex_0e091d })
                hl(0, 'NormalFloat', { fg = colors.hex_C8E967, bg = colors.hex_061F23 })
                hl(0, 'FloatBorder', { fg = colors.hex_9147a8, bg = colors.hex_061F23 })
                hl(0, 'FloatTitle', { fg = colors.hex_04C5F0, bg = colors.hex_061F23, bold = true })
                hl(0, 'Cursor', { fg = colors.hex_0e091d, bg = colors.hex_9147a8 })
                hl(0, 'CursorLine', { bg = colors.hex_061F23 })
                hl(0, 'CursorLineNr', { fg = colors.hex_04C5F0, bold = true })
                hl(0, 'LineNr', { fg = colors.hex_8CB319 })
                hl(0, 'Visual', { bg = colors.hex_092F34 })
                hl(0, 'VisualNOS', { bg = colors.hex_092F34 })
                hl(0, 'Search', { fg = colors.hex_0e091d, bg = colors.hex_04C5F0 })
                hl(0, 'IncSearch', { fg = colors.hex_0e091d, bg = colors.hex_9147a8 })
                hl(0, 'MatchParen', { fg = colors.hex_FD3E6A, bold = true })

                -- Syntax highlighting
                hl(0, 'Comment', { fg = colors.hex_126069, italic = true })
                hl(0, 'Constant', { fg = colors.hex_ffbe74 })
                hl(0, 'String', { fg = colors.hex_FF7F41 })
                hl(0, 'Character', { fg = colors.hex_FF7F41 })
                hl(0, 'Number', { fg = colors.hex_ffbe74 })
                hl(0, 'Boolean', { fg = colors.hex_ffbe74 })
                hl(0, 'Float', { fg = colors.hex_ffbe74 })
                hl(0, 'Identifier', { fg = colors.hex_C8E967 })
                hl(0, 'Function', { fg = colors.hex_7cd699 })
                hl(0, 'Statement', { fg = colors.hex_9147a8 })
                hl(0, 'Conditional', { fg = colors.hex_9147a8 })
                hl(0, 'Repeat', { fg = colors.hex_9147a8 })
                hl(0, 'Label', { fg = colors.hex_E20342 })
                hl(0, 'Operator', { fg = colors.hex_A8D61F })
                hl(0, 'Keyword', { fg = colors.hex_9147a8 })
                hl(0, 'Exception', { fg = colors.hex_f93d3b })
                hl(0, 'PreProc', { fg = colors.hex_FD3E6A })
                hl(0, 'Include', { fg = colors.hex_FD3E6A })
                hl(0, 'Define', { fg = colors.hex_FD3E6A })
                hl(0, 'Macro', { fg = colors.hex_FD3E6A })
                hl(0, 'PreCondit', { fg = colors.hex_FD3E6A })
                hl(0, 'Type', { fg = colors.hex_E20342 })
                hl(0, 'StorageClass', { fg = colors.hex_E20342 })
                hl(0, 'Structure', { fg = colors.hex_E20342 })
                hl(0, 'Typedef', { fg = colors.hex_E20342 })
                hl(0, 'Special', { fg = colors.hex_04C5F0 })
                hl(0, 'SpecialChar', { fg = colors.hex_04C5F0 })
                hl(0, 'Tag', { fg = colors.hex_9147a8 })
                hl(0, 'Delimiter', { fg = colors.hex_A8D61F })
                hl(0, 'SpecialComment', { fg = colors.hex_126069, italic = true, bold = true })
                hl(0, 'Debug', { fg = colors.hex_f93d3b })
                hl(0, 'Underlined', { underline = true })
                hl(0, 'Error', { fg = colors.hex_f93d3b, bold = true })
                hl(0, 'Todo', { fg = colors.hex_04C5F0, bold = true })

                -- UI elements
                hl(0, 'StatusLine', { fg = colors.hex_C8E967, bg = colors.hex_092F34 })
                hl(0, 'StatusLineNC', { fg = colors.hex_8CB319, bg = colors.hex_061F23 })
                hl(0, 'TabLine', { fg = colors.hex_8CB319, bg = colors.hex_092F34 })
                hl(0, 'TabLineFill', { bg = colors.hex_061F23 })
                hl(0, 'TabLineSel', { fg = colors.hex_9147a8, bg = colors.hex_0e091d, bold = true })
                hl(0, 'Pmenu', { fg = colors.hex_C8E967, bg = colors.hex_061F23 })
                hl(0, 'PmenuSel', { fg = colors.hex_04C5F0, bg = colors.hex_0C3F45, bold = true })
                hl(0, 'PmenuSbar', { bg = colors.hex_092F34 })
                hl(0, 'PmenuThumb', { bg = colors.hex_E20342 })
                hl(0, 'WildMenu', { fg = colors.hex_0e091d, bg = colors.hex_9147a8 })
                hl(0, 'VertSplit', { fg = colors.hex_0C3F45 })
                hl(0, 'WinSeparator', { fg = colors.hex_0C3F45 })
                hl(0, 'Folded', { fg = colors.hex_8CB319, bg = colors.hex_061F23 })
                hl(0, 'FoldColumn', { fg = colors.hex_FD3E6A, bg = colors.hex_0e091d })
                hl(0, 'SignColumn', { fg = colors.hex_E20342, bg = colors.hex_0e091d })
                hl(0, 'ColorColumn', { bg = colors.hex_061F23 })

                -- Diff highlighting
                hl(0, 'DiffAdd', { fg = colors.hex_FF7F41, bg = colors.hex_061F23 })
                hl(0, 'DiffChange', { fg = colors.hex_04C5F0, bg = colors.hex_061F23 })
                hl(0, 'DiffDelete', { fg = colors.hex_f93d3b, bg = colors.hex_061F23 })
                hl(0, 'DiffText', { fg = colors.hex_A8D61F, bg = colors.hex_0C3F45, bold = true })

                -- Git signs
                hl(0, 'GitSignsAdd', { fg = colors.hex_FF7F41 })
                hl(0, 'GitSignsChange', { fg = colors.hex_04C5F0 })
                hl(0, 'GitSignsDelete', { fg = colors.hex_f93d3b })

                -- Diagnostic highlights
                hl(0, 'DiagnosticError', { fg = colors.hex_f93d3b })
                hl(0, 'DiagnosticWarn', { fg = colors.hex_04C5F0 })
                hl(0, 'DiagnosticInfo', { fg = colors.hex_ffbe74 })
                hl(0, 'DiagnosticHint', { fg = colors.hex_FD3E6A })
                hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.hex_f93d3b })
                hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = colors.hex_04C5F0 })
                hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = colors.hex_ffbe74 })
                hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = colors.hex_FD3E6A })

                -- LSP highlights
                hl(0, 'LspReferenceText', { bg = colors.hex_092F34 })
                hl(0, 'LspReferenceRead', { bg = colors.hex_092F34 })
                hl(0, 'LspReferenceWrite', { bg = colors.hex_092F34, underline = true })

                -- Treesitter highlights
                hl(0, '@variable', { fg = colors.hex_C8E967 })
                hl(0, '@variable.builtin', { fg = colors.hex_ffbe74 })
                hl(0, '@variable.parameter', { fg = colors.hex_A8D61F })
                hl(0, '@variable.member', { fg = colors.hex_7cd699 })
                hl(0, '@constant', { fg = colors.hex_ffbe74 })
                hl(0, '@constant.builtin', { fg = colors.hex_ffbe74 })
                hl(0, '@constant.macro', { fg = colors.hex_04C5F0 })
                hl(0, '@module', { fg = colors.hex_E20342 })
                hl(0, '@module.builtin', { fg = colors.hex_E20342 })
                hl(0, '@label', { fg = colors.hex_E20342 })
                hl(0, '@string', { fg = colors.hex_FF7F41 })
                hl(0, '@string.escape', { fg = colors.hex_04C5F0 })
                hl(0, '@string.special', { fg = colors.hex_04C5F0 })
                hl(0, '@string.regexp', { fg = colors.hex_FD3E6A })
                hl(0, '@character', { fg = colors.hex_FF7F41 })
                hl(0, '@character.special', { fg = colors.hex_04C5F0 })
                hl(0, '@boolean', { fg = colors.hex_ffbe74 })
                hl(0, '@number', { fg = colors.hex_ffbe74 })
                hl(0, '@number.float', { fg = colors.hex_ffbe74 })
                hl(0, '@type', { fg = colors.hex_E20342 })
                hl(0, '@type.builtin', { fg = colors.hex_E20342 })
                hl(0, '@type.definition', { fg = colors.hex_E20342 })
                hl(0, '@attribute', { fg = colors.hex_FD3E6A })
                hl(0, '@property', { fg = colors.hex_7cd699 })
                hl(0, '@function', { fg = colors.hex_7cd699 })
                hl(0, '@function.builtin', { fg = colors.hex_7cd699 })
                hl(0, '@function.call', { fg = colors.hex_7cd699 })
                hl(0, '@function.macro', { fg = colors.hex_FD3E6A })
                hl(0, '@function.method', { fg = colors.hex_7cd699 })
                hl(0, '@function.method.call', { fg = colors.hex_7cd699 })
                hl(0, '@constructor', { fg = colors.hex_E20342 })
                hl(0, '@operator', { fg = colors.hex_A8D61F })
                hl(0, '@keyword', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.coroutine', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.function', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.operator', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.import', { fg = colors.hex_FD3E6A })
                hl(0, '@keyword.conditional', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.repeat', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.return', { fg = colors.hex_9147a8 })
                hl(0, '@keyword.exception', { fg = colors.hex_f93d3b })
                hl(0, '@comment', { fg = colors.hex_126069, italic = true })
                hl(0, '@comment.documentation', { fg = colors.hex_126069, italic = true })
                hl(0, '@punctuation', { fg = colors.hex_A8D61F })
                hl(0, '@punctuation.bracket', { fg = colors.hex_A8D61F })
                hl(0, '@punctuation.delimiter', { fg = colors.hex_A8D61F })
                hl(0, '@punctuation.special', { fg = colors.hex_04C5F0 })
                hl(0, '@tag', { fg = colors.hex_9147a8 })
                hl(0, '@tag.attribute', { fg = colors.hex_E20342 })
                hl(0, '@tag.delimiter', { fg = colors.hex_A8D61F })

                -- Telescope
                hl(0, 'TelescopeBorder', { fg = colors.hex_9147a8 })
                hl(0, 'TelescopePromptBorder', { fg = colors.hex_E20342 })
                hl(0, 'TelescopeResultsBorder', { fg = colors.hex_FF7F41 })
                hl(0, 'TelescopePreviewBorder', { fg = colors.hex_ffbe74 })
                hl(0, 'TelescopeSelection', { fg = colors.hex_04C5F0, bg = colors.hex_092F34, bold = true })
                hl(0, 'TelescopeMatching', { fg = colors.hex_9147a8, bold = true })

                -- Neo-tree
                hl(0, 'NeoTreeNormal', { fg = colors.hex_C8E967, bg = colors.hex_0e091d })
                hl(0, 'NeoTreeDirectoryName', { fg = colors.hex_E20342 })
                hl(0, 'NeoTreeDirectoryIcon', { fg = colors.hex_FF7F41 })
                hl(0, 'NeoTreeFileName', { fg = colors.hex_C8E967 })
                hl(0, 'NeoTreeFileIcon', { fg = colors.hex_A8D61F })
                hl(0, 'NeoTreeIndentMarker', { fg = colors.hex_0C3F45 })
                hl(0, 'NeoTreeRootName', { fg = colors.hex_9147a8, bold = true })
                hl(0, 'NeoTreeGitModified', { fg = colors.hex_04C5F0 })
                hl(0, 'NeoTreeGitAdded', { fg = colors.hex_FF7F41 })
                hl(0, 'NeoTreeGitDeleted', { fg = colors.hex_f93d3b })

                -- Terminal colors (matching theme palette)
                vim.g.terminal_color_0 = '#061F23'  -- Very dark teal-blue
                vim.g.terminal_color_1 = '#E20342'  -- Bright red
                vim.g.terminal_color_2 = '#FF7F41'  -- Bright orange
                vim.g.terminal_color_3 = '#04C5F0'  -- Bright cyan-blue
                vim.g.terminal_color_4 = '#ffbe74'  -- Light orange-yellow
                vim.g.terminal_color_5 = '#FD3E6A'  -- Vibrant pink-red
                vim.g.terminal_color_6 = '#7cd699'  -- Light blue-green
                vim.g.terminal_color_7 = '#A8D61F'  -- Bright yellow-green
                vim.g.terminal_color_8 = '#0C3F45'  -- Dark muted blue-green
                vim.g.terminal_color_9 = '#f93d3b'  -- Vibrant red
                vim.g.terminal_color_10 = '#FF7F41' -- Bright orange
                vim.g.terminal_color_11 = '#ffbe74' -- Light orange-yellow
                vim.g.terminal_color_12 = '#dd66ff' -- Bright magenta-purple
                vim.g.terminal_color_13 = '#9147a8' -- Dark purple
                vim.g.terminal_color_14 = '#ff99dd' -- Light pink
                vim.g.terminal_color_15 = '#ffffff' -- Pure white
            end,
        },
    },
}
