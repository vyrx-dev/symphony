#!/bin/bash
# waybar - symlink colors and reload
src="$CURRENT_LINK/.config/waybar/colors.css"
[[ -f "$src" ]] || exit 0
ln -sf "$src" "$HOME/.config/waybar/colors.css"
pgrep -x waybar &>/dev/null && pkill -SIGUSR2 waybar 2>/dev/null
exit 0
