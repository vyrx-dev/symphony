#!/bin/bash
# vesktop - symlink discord theme
src="$CURRENT_LINK/.config/vesktop/themes/symphony-discord.css"
[[ -f "$src" ]] || exit 0
mkdir -p "$HOME/.config/vesktop/themes"
ln -sf "$src" "$HOME/.config/vesktop/themes/symphony-discord.css"
