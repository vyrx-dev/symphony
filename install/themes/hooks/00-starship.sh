#!/bin/bash
# starship - symlink config
src="$CURRENT_LINK/starship.toml"
[[ -f "$src" ]] || exit 0
ln -sf "$src" "$HOME/.config/starship.toml"
