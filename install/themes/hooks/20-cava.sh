#!/bin/bash
# cava - merge colors into config and reload
config="$HOME/.config/cava/config"
colors="$CURRENT_LINK/.config/cava-config"
[[ ! -f "$colors" ]] && colors="$CURRENT_LINK/.config/cava/colors.ini"
[[ -f "$colors" && -f "$config" ]] || exit 0

# backup original config once
[[ ! -f "$config.backup" ]] && cp "$config" "$config.backup"

# replace [color] section
sed -i '/^\[color\]/,/^\[/{ /^\[color\]/d; /^\[/!d; }' "$config"
cat "$colors" >> "$config"

pgrep -x cava &>/dev/null && pkill -USR1 cava 2>/dev/null
exit 0
