# #!/bin/bash
# # nvim - symlink theme.lua (skip for dynamic theme)
#
# # dynamic theme uses matugen, no static theme.lua
# current_theme=$(cat ~/.config/symphony/.current-theme 2>/dev/null)
# [[ "$current_theme" == "dynamic" ]] && exit 0
#
# theme_file="$CURRENT_LINK/.config/nvim/theme.lua"
# target_file="$HOME/.config/nvim/lua/plugins/theme.lua"
#
# [[ -f "$theme_file" ]] || exit 0
#
# mkdir -p "$(dirname "$target_file")"
# ln -sf "$theme_file" "$target_file"
