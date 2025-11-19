#!/bin/bash

# Wallpaper Script Patches
# Adds theme mode checking to prevent matugen from running when using custom themes

echo "🔧 Patching wallpaper scripts..."
echo ""

# Patch selectWall
SELECTWALL="$HOME/.config/rofi/scripts/selectWall"
if [ -f "$SELECTWALL" ]; then
    # Create backup
    cp "$SELECTWALL" "${SELECTWALL}.backup"
    
    # Add mode check after shebang
    sed -i '2i\\n# Check if custom theme is active\nCURRENT_THEME=$(cat ~/.current-theme 2>/dev/null || echo "matugen")\nif [[ "$CURRENT_THEME" != "matugen" ]]; then\n    notify-send "Theme Locked" "Using custom theme: $CURRENT_THEME\\nUse switch-theme.sh to change themes"\n    exit 0\nfi\n' "$SELECTWALL"
    
    echo "✓ Patched selectWall"
else
    echo "⚠ selectWall not found at $SELECTWALL"
fi

# Patch wallPicker
WALLPICKER="$HOME/.config/rofi/scripts/wallPicker"
if [ -f "$WALLPICKER" ]; then
    # Create backup
    cp "$WALLPICKER" "${WALLPICKER}.backup"
    
    # This one just changes wallpaper without matugen, but add notice
    sed -i '2i\\n# Note: This only changes wallpaper, not theme colors' "$WALLPICKER"
    
    echo "✓ Patched wallPicker (info added)"
else
    echo "⚠ wallPicker not found at $WALLPICKER"
fi

# Patch change-theme
CHANGETHEME="$HOME/.config/hypr/scripts/change-theme"
if [ -f "$CHANGETHEME" ]; then
    # Create backup
    cp "$CHANGETHEME" "${CHANGETHEME}.backup"
    
    # Add mode check after shebang
    sed -i '2i\\n# Check if custom theme is active\nCURRENT_THEME=$(cat ~/.current-theme 2>/dev/null || echo "matugen")\nif [[ "$CURRENT_THEME" != "matugen" ]]; then\n    notify-send "Theme Locked" "Using custom theme: $CURRENT_THEME\\nUse switch-theme.sh to change themes"\n    exit 0\nfi\n' "$CHANGETHEME"
    
    echo "✓ Patched change-theme"
else
    echo "⚠ change-theme not found at $CHANGETHEME"
fi

echo ""
echo "✅ Wallpaper scripts patched!"
echo ""
echo "📝 Backups created with .backup extension"
echo "   To restore: mv script.backup script"
