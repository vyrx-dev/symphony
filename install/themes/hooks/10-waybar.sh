#!/bin/bash
# waybar - symlink colors (auto-reloads via reload_style_on_change)
src="$CURRENT_LINK/.config/waybar/colors.css"
[[ -f "$src" ]] || exit 0
ln -sf "$src" "$HOME/.config/waybar/colors.css"
exit 0
