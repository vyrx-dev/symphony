#!/bin/bash
# rofi - symlink colors
src="$CURRENT_LINK/.config/rofi/colors.rasi"
[[ -f "$src" ]] || exit 0
ln -sf "$src" "$HOME/.config/rofi/colors.rasi"
