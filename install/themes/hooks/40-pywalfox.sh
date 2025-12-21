#!/bin/bash
# pywalfox - copy colors and update firefox
src="$CURRENT_LINK/.cache/wal"
dst="$HOME/.cache/wal"
[[ -f "$src/colors.json" ]] || exit 0
command -v pywalfox &>/dev/null || exit 0

mkdir -p "$dst"
cp "$src/colors.json" "$dst/colors.json" 2>/dev/null
[[ -f "$src/colors" ]] && cp "$src/colors" "$dst/colors" 2>/dev/null
pywalfox update &>/dev/null &
exit 0
