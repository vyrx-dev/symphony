#!/bin/bash
# btop - symlink theme and reload
src="$CURRENT_LINK/btop/themes/current.theme"
[[ -f "$src" ]] || exit 0

mkdir -p "$HOME/.config/btop/themes"
ln -sf "$src" "$HOME/.config/btop/themes/current.theme"

# Fix hardcoded path in btop.conf
btop_conf="$HOME/.config/btop/btop.conf"
if [[ -f "$btop_conf" ]]; then
    sed -i -E "s|/home/[^/]+/.config|$HOME/.config|g" "$btop_conf"
fi

pgrep -x btop &>/dev/null && pkill -SIGUSR2 btop 2>/dev/null
exit 0
