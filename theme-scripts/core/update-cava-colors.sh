#!/bin/bash

# Script to update cava colors in main config based on theme
THEME=$1
THEMES_DIR="$HOME/dotfiles/themes"
CAVA_CONFIG="$HOME/.config/cava/config"
TEMP_FILE="$HOME/.config/cava/config.tmp"

if [ -z "$THEME" ]; then
    echo "Usage: $0 <theme-name>"
    exit 1
fi

# Special handling for matugen - it uses template
if [ "$THEME" = "matugen" ]; then
    CAVA_COLORS="$HOME/.config/matugen/cava-colors.ini"
    if [ -f "$CAVA_COLORS" ]; then
        # Use matugen generated colors
        {
            sed -n '1,/^\[color\]$/p' "$CAVA_CONFIG"
            tail -n +2 "$CAVA_COLORS"
            sed -n '/^# ; background = default/,$p' "$CAVA_CONFIG"
        } > "$TEMP_FILE"
        mv "$TEMP_FILE" "$CAVA_CONFIG"
        
        # Restart cava if it's running
        if pgrep -x cava > /dev/null; then
            pkill -USR1 cava 2>/dev/null || pkill cava
            echo "✅ Updated cava colors for matugen (cava restarted)"
        else
            echo "✅ Updated cava colors for matugen"
        fi
        exit 0
    fi
fi

if [ ! -f "$THEMES_DIR/$THEME/.config/cava" ]; then
    echo "No cava colors found for theme: $THEME"
    exit 1
fi

# Create new config with updated colors
{
    # Copy everything up to and including the [color] section header
    sed -n '1,/^\[color\]$/p' "$CAVA_CONFIG"
    
    # Skip the [color] line from theme file and insert gradient colors
    tail -n +2 "$THEMES_DIR/$THEME/.config/cava"
    
    # Copy everything after gradient colors (from "# ; background = default")
    sed -n '/^# ; background = default/,$p' "$CAVA_CONFIG"
} > "$TEMP_FILE"

mv "$TEMP_FILE" "$CAVA_CONFIG"

# Restart cava if it's running
if pgrep -x cava > /dev/null; then
    pkill -USR1 cava 2>/dev/null || pkill cava
    echo "✅ Updated cava colors for $THEME (cava restarted)"
else
    echo "✅ Updated cava colors for $THEME"
fi
