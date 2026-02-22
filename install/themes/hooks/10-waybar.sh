#!/bin/bash
# waybar - symlink colors and restart
src="$CURRENT_LINK/waybar/colors.css"
[[ -f "$src" ]] || exit 0
ln -sf "$src" "$HOME/.config/waybar/colors.css"

pkill -x waybar 2>/dev/null
sleep 0.3
setsid uwsm-app -- waybar >/dev/null 2>&1 &
exit 0
