#!/bin/bash
# cava - symlink config and reload
src="$CURRENT_LINK/.config/cava/config"
dst="$HOME/.config/cava/config"

[[ -f "$src" ]] || exit 0
ln -sf "$src" "$dst"

pgrep -x cava &>/dev/null && pkill -USR1 cava 2>/dev/null
exit 0
