#!/bin/bash
# btop - symlink theme and reload
src="$CURRENT_LINK/.config/btop/themes/current.theme"
[[ -f "$src" ]] || exit 0
mkdir -p "$HOME/.config/btop/themes"
ln -sf "$src" "$HOME/.config/btop/themes/current.theme"
pgrep -x btop &>/dev/null && pkill -SIGUSR2 btop 2>/dev/null
exit 0
