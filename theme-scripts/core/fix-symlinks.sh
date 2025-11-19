#!/bin/bash

# Fix symlinks for current theme
CURRENT_THEME=$(cat ~/.current-theme 2>/dev/null || echo "zen")
THEMES_DIR="$HOME/dotfiles/themes"

echo "Fixing symlinks for theme: $CURRENT_THEME"

# Create directories
mkdir -p ~/.config/hypr/theme
mkdir -p ~/.config/rofi
mkdir -p ~/.config

# Hyprland theme
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/hypr/theme/colors.conf" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/hypr/theme/colors.conf" "$HOME/.config/hypr/theme/colors.conf"
    echo "✅ Linked hypr colors.conf"
fi

if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/hypr/theme/overrides.conf" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/hypr/theme/overrides.conf" "$HOME/.config/hypr/theme/overrides.conf"
    echo "✅ Linked hypr overrides.conf"
fi

# Rofi colors
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/rofi/colors.rasi" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/rofi/colors.rasi" "$HOME/.config/rofi/colors.rasi"
    echo "✅ Linked rofi colors.rasi"
fi

# Starship config (for non-matugen themes)
if [ "$CURRENT_THEME" != "matugen" ] && [ -f "$THEMES_DIR/$CURRENT_THEME/.config/starship.toml" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/starship.toml" "$HOME/.config/starship.toml"
    echo "✅ Linked starship.toml"
fi

# Kitty theme files
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/kitty/colors.conf" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/kitty/colors.conf" "$HOME/.config/kitty/colors.conf"
    echo "✅ Linked kitty colors.conf"
fi
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/kitty/overrides.conf" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/kitty/overrides.conf" "$HOME/.config/kitty/overrides.conf"
    echo "✅ Linked kitty overrides.conf"
fi

# Alacritty theme files
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/alacritty/colors.toml" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/alacritty/colors.toml" "$HOME/.config/alacritty/colors.toml"
    echo "✅ Linked alacritty colors.toml"
fi
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/alacritty/overrides.toml" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/alacritty/overrides.toml" "$HOME/.config/alacritty/overrides.toml"
    echo "✅ Linked alacritty overrides.toml"
fi

# Btop theme file
mkdir -p "$HOME/.config/btop/themes"
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/btop/themes/current.theme" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/btop/themes/current.theme" "$HOME/.config/btop/themes/current.theme"
    echo "✅ Linked btop current.theme"
fi

# Cava colors - directly update config file
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/cava" ]; then
    "$HOME/dotfiles/theme-scripts/core/update-cava-colors.sh" "$CURRENT_THEME" >/dev/null 2>&1
    echo "✅ Updated cava colors"
fi

# RMPC theme - directly update theme file
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/rmpc/themes/theme.ron" ] || [ "$CURRENT_THEME" = "matugen" ]; then
    "$HOME/dotfiles/theme-scripts/core/update-rmpc-theme.sh" "$CURRENT_THEME" >/dev/null 2>&1
    echo "✅ Updated rmpc theme"
fi

# Waybar colors
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/waybar/colors.css" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/waybar/colors.css" "$HOME/.config/waybar/colors.css"
    echo "✅ Linked waybar colors.css"
fi

# Vesktop theme
mkdir -p "$HOME/.config/vesktop/themes"
if [ "$CURRENT_THEME" = "matugen" ]; then
    # For matugen, use the symphony current directory
    if [ -f "$HOME/.config/symphony/current/.config/vesktop/themes/midnight-discord.css" ]; then
        ln -sf "$HOME/.config/symphony/current/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
        echo "✅ Linked vesktop midnight-discord.css"
    fi
elif [ -f "$THEMES_DIR/$CURRENT_THEME/.config/vesktop/themes/midnight-discord.css" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
    echo "✅ Linked vesktop midnight-discord.css"
fi

# GTK colors (theme-specific)
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/gtk-3.0/colors.css" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/gtk-3.0/colors.css" "$HOME/.config/gtk-3.0/colors.css"
    echo "✅ Linked GTK-3.0 colors.css"
fi
if [ -f "$THEMES_DIR/$CURRENT_THEME/.config/gtk-4.0/colors.css" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.config/gtk-4.0/colors.css" "$HOME/.config/gtk-4.0/colors.css"
    echo "✅ Linked GTK-4.0 colors.css"
fi

# Pywal colors for Firefox pywalfox integration
mkdir -p "$HOME/.cache/wal"
if [ -f "$THEMES_DIR/$CURRENT_THEME/.cache/wal/colors.json" ]; then
    ln -sf "$THEMES_DIR/$CURRENT_THEME/.cache/wal/colors.json" "$HOME/.cache/wal/colors.json"
    echo "✅ Linked pywal colors.json"
fi

echo ""
echo "Symlinks fixed! Reloading applications..."

# Apply GTK dark theme using nwg-look
nwg-look -a >/dev/null 2>&1
echo "✅ Applied GTK dark theme"

hyprctl reload 2>&1
killall -SIGUSR1 kitty 2>/dev/null
pkill -SIGUSR1 alacritty 2>/dev/null  
pkill -SIGUSR2 btop 2>/dev/null
pkill -SIGUSR2 waybar 2>/dev/null
swaync-client -rs 2>/dev/null

# Update Firefox pywalfox colors
pywalfox update >/dev/null 2>&1 &
echo "✅ Updated Firefox pywalfox"

echo "Done!"
