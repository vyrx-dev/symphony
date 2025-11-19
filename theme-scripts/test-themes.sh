#!/bin/bash

# Symphony Theme Test - Verify theme integration

CURRENT=$(cat ~/.current-theme 2>/dev/null || echo "unknown")

echo "Testing: $CURRENT"
echo

check() {
    [ -f "$2" ] && echo "✓ $1" || echo "✗ $1"
}

check "Starship   " "$HOME/.config/starship.toml"
check "RMPC       " "$HOME/.config/rmpc/themes/current.ron"
check "Rofi       " "$HOME/.config/rofi/colors.rasi"
check "Firefox    " "$HOME/.cache/wal/colors.json"
check "Waybar     " "$HOME/.config/waybar/style.css"
check "Yazi       " "$HOME/.config/yazi/theme.toml"
check "Vesktop    " "$HOME/.config/vesktop/themes/midnight-discord.css"
check "Btop       " "$HOME/.config/btop/themes/current.theme"
check "GTK        " "$HOME/.config/gtk-3.0/colors.css"

echo
