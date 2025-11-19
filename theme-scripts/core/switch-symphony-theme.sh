#!/bin/bash

# Symphony Theme Switcher
# Switches between themes in ~/.config/symphony/themes/

SYMPHONY_THEMES="$HOME/.config/symphony/themes"
SYMPHONY_CURRENT="$HOME/.config/symphony/current"
CURRENT_THEME_FILE="$HOME/.config/symphony/.current-theme"

# Get list of available themes
get_themes() {
    if [ ! -d "$SYMPHONY_THEMES" ]; then
        echo "Error: Symphony themes directory not found"
        exit 1
    fi
    
    find "$SYMPHONY_THEMES" -mindepth 1 -maxdepth 1 -type l -o -type d | while read -r theme_path; do
        basename "$theme_path"
    done | sort
}

# Get current theme
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "none")

# Show theme selector with rofi
SELECTED=$(get_themes | rofi -i -dmenu -p "Symphony Theme")

# Exit if nothing selected
[ -z "$SELECTED" ] && exit 0

# Exit if same theme
[ "$SELECTED" = "$CURRENT_THEME" ] && {
    notify-send "Symphony" "Already using $SELECTED"
    exit 0
}

# Check if theme exists
THEME_PATH="$SYMPHONY_THEMES/$SELECTED"
if [ ! -d "$THEME_PATH" ]; then
    notify-send "Error" "Theme not found: $SELECTED"
    exit 1
fi

# Create current directory if it doesn't exist
mkdir -p "$SYMPHONY_CURRENT"

# Remove old symlinks from current
find "$SYMPHONY_CURRENT" -type l -delete

# Map files to their destination config paths
create_symlink() {
    local source="$1"
    local filename=$(basename "$source")
    local dest=""
    
    case "$filename" in
        # Terminal configs
        alacritty.toml)
            dest="$HOME/.config/alacritty/colors.toml"
            ;;
        kitty.conf)
            dest="$HOME/.config/kitty/colors-symphony.conf"
            ;;
        ghostty.conf)
            dest="$HOME/.config/ghostty/themes/symphony"
            ;;
        
        # Window manager
        hyprland.conf)
            dest="$HOME/.config/hypr/theme/symphony.conf"
            ;;
        hyprlock.conf)
            dest="$HOME/.config/hypr/hyprlock-symphony.conf"
            ;;
        
        # Applications
        btop.theme)
            dest="$HOME/.config/btop/themes/symphony.theme"
            ;;
        waybar.css)
            dest="$HOME/.config/waybar/symphony-colors.css"
            ;;
        neovim.lua)
            dest="$HOME/.config/nvim/lua/plugins/symphony-theme.lua"
            ;;
        vscode.json)
            dest="$HOME/.config/Code/User/symphony-colors.json"
            ;;
        
        # Other
        icons.theme)
            dest="$HOME/.config/symphony/current/icons.theme"
            ;;
        chromium.theme)
            dest="$HOME/.config/symphony/current/chromium.theme"
            ;;
        swayosd.css)
            dest="$HOME/.config/swayosd/symphony.css"
            ;;
    esac
    
    # Create symlink if destination is set
    if [ -n "$dest" ]; then
        mkdir -p "$(dirname "$dest")"
        ln -sf "$source" "$dest"
        # Also create a copy in current for reference
        ln -sf "$source" "$SYMPHONY_CURRENT/$filename"
    fi
}

# Create symlinks for all theme files
while IFS= read -r -d '' file; do
    create_symlink "$file"
done < <(find "$THEME_PATH" -maxdepth 1 -type f -print0)

# Handle wallpaper
WALLPAPER=$(find "$THEME_PATH/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | head -1)
if [ -n "$WALLPAPER" ]; then
    swww query &>/dev/null || swww-daemon --format xrgb &
    swww img "$WALLPAPER" --transition-fps 60 --transition-type=any --transition-duration=1
    ln -sf "$WALLPAPER" "$SYMPHONY_CURRENT/wallpaper"
fi

# Save current theme
echo "$SELECTED" > "$CURRENT_THEME_FILE"

# Reload applications
hyprctl reload 2>/dev/null
killall -SIGUSR1 kitty 2>/dev/null
pkill -SIGUSR1 alacritty 2>/dev/null
pkill -SIGUSR2 btop 2>/dev/null
pkill -SIGUSR2 waybar 2>/dev/null
ghostty +reload-config 2>/dev/null
killall -SIGUSR2 ghostty 2>/dev/null

# Send notification
if [ -n "$WALLPAPER" ]; then
    notify-send -i "$WALLPAPER" "Symphony Theme" "Switched to: $SELECTED"
else
    notify-send "Symphony Theme" "Switched to: $SELECTED"
fi
