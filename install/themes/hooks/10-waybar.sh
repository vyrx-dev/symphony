#!/bin/bash
# waybar - symlink colors and restart
src="$CURRENT_LINK/.config/waybar/colors.css"
[[ -f "$src" ]] || exit 0
ln -sf "$src" "$HOME/.config/waybar/colors.css"

if pgrep -x waybar &>/dev/null; then
	pkill -x waybar
	setsid uwsm-app -- waybar >/dev/null 2>&1 &
fi
exit 0
