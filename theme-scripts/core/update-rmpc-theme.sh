#!/bin/bash

# Script to update rmpc theme based on current theme

THEME=$1
THEMES_DIR="$HOME/dotfiles/themes"
RMPC_CONFIG_DIR="$HOME/.config/rmpc"
RMPC_THEMES_DIR="$RMPC_CONFIG_DIR/themes"

if [ -z "$THEME" ]; then
    echo "Usage: $0 <theme-name>"
    exit 1
fi

# Create themes directory if it doesn't exist
mkdir -p "$RMPC_THEMES_DIR"

# Special handling for matugen - it writes directly to current.ron
if [ "$THEME" = "matugen" ]; then
    # Just ensure the config uses "current" theme
    if [ -f "$RMPC_CONFIG_DIR/config.ron" ]; then
        sed -i 's/theme: "[^"]*"/theme: "current"/' "$RMPC_CONFIG_DIR/config.ron"
    fi
    
    echo "✅ rmpc theme for matugen (updated directly by matugen)"
    exit 0
fi

# Check if theme file exists
THEME_FILE="$THEMES_DIR/$THEME/.config/rmpc/themes/theme.ron"
if [ ! -f "$THEME_FILE" ]; then
    echo "⚠️  No rmpc theme found for: $THEME"
    exit 1
fi

# Copy theme to active location
cp "$THEME_FILE" "$RMPC_THEMES_DIR/current.ron"

# Update config.ron to use the current theme
if [ -f "$RMPC_CONFIG_DIR/config.ron" ]; then
    sed -i 's/theme: "[^"]*"/theme: "current"/' "$RMPC_CONFIG_DIR/config.ron"
fi

echo "✅ Updated rmpc theme for $THEME"
