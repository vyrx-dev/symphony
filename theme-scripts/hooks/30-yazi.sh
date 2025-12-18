#!/bin/bash
# yazi - symlink theme (applies on next launch)
src="$CURRENT_LINK/.config/yazi/theme.toml"
[[ -f "$src" ]] || exit 0
mkdir -p "$HOME/.config/yazi"
ln -sf "$src" "$HOME/.config/yazi/theme.toml"
