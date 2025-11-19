#!/bin/bash

# This script creates full cava config files for each theme
# by copying the base config and inserting theme colors

BASE_CONFIG="$HOME/.config/cava/config"
THEMES_DIR="$HOME/dotfiles/themes"

# Backup current config
if [ ! -f "$HOME/.config/cava/config.backup" ]; then
    cp "$BASE_CONFIG" "$HOME/.config/cava/config.backup"
fi

# For each theme, create a full config with colors
create_cava_config() {
    local theme=$1
    local bg=$2
    shift 2
    local colors=("$@")
    
    local theme_config="$THEMES_DIR/$theme/.config/cava-config"
    
    # Copy everything except the [color] section
    sed -n '1,232p' "$HOME/.config/cava/config.backup" > "$theme_config"
    
    # Add color section
    cat >> "$theme_config" << COLOREOF
[color]

background = '$bg'
gradient = 1
gradient_count = ${#colors[@]}
COLOREOF
    
    # Add gradient colors
    for i in "${!colors[@]}"; do
        echo "gradient_color_$((i+1)) = '${colors[$i]}'" >> "$theme_config"
    done
    
    # Add rest of config
    sed -n '249,$p' "$HOME/.config/cava/config.backup" >> "$theme_config"
    
    echo "Created cava config for $theme"
}

# Create configs for each theme
create_cava_config "zen" "#000000" "#545454" "#666666" "#8a8a8a" "#a0a0a0"
create_cava_config "aamis" "#0a0a0a" "#c94d5c" "#d4a345" "#c9a573" "#cd9530" "#d1b58f" "#d4c2af"
create_cava_config "carnage" "#0d0f0d" "#b96f44" "#7e8a81" "#839ba1" "#95a9af" "#c89369" "#dbc3b2"
create_cava_config "gruvbox-material" "#0d0e0e" "#d15951" "#bf9548" "#949f56" "#77a070" "#6a9a8f" "#ba7589"
create_cava_config "osaka-jade" "#0d1410" "#3f8453" "#387a3e" "#3d7a5e" "#24ba9a" "#5ea197" "#86d09a"
create_cava_config "sakura" "#080305" "#ce4a59" "#ba8d6b" "#d8807f" "#bf8a56" "#cea680" "#e1b891"
create_cava_config "tokyo-night" "#13141d" "#343a3b" "#80d4db" "#80d4db" "#dee4e4"
create_cava_config "void" "#030008" "#a89de5" "#a180dd" "#9a80cc" "#8c9ee5" "#b18cde" "#a8b4e5"

echo "All cava configs created!"
