#!/bin/bash
# rmpc - symlink theme and hot-reload
src="$CURRENT_LINK/.config/rmpc/themes/current.ron"
[[ ! -f "$src" ]] && src="$CURRENT_LINK/.config/rmpc/themes/theme.ron"
[[ -f "$src" ]] || exit 0

mkdir -p "$HOME/.config/rmpc/themes"
ln -sf "$src" "$HOME/.config/rmpc/themes/current.ron"
pgrep -x rmpc &>/dev/null && rmpc remote set theme "$src" 2>/dev/null
exit 0
