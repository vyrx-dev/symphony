#!/bin/bash

# Create rofi colors for all themes based on their kitty colors
# This extracts colors from kitty configs and creates Material Design 3 inspired color schemes

THEMES_DIR="$HOME/dotfiles/themes"

create_rofi_colors() {
    local theme=$1
    local kitty_colors="$THEMES_DIR/$theme/.config/kitty/colors.conf"
    local rofi_dir="$THEMES_DIR/$theme/.config/rofi"
    local rofi_colors="$rofi_dir/colors.rasi"
    
    if [ ! -f "$kitty_colors" ]; then
        echo "⚠️  Skipping $theme - no kitty colors found"
        return
    fi
    
    # Extract colors from kitty config
    bg=$(grep "^background" "$kitty_colors" | awk '{print $2}')
    fg=$(grep "^foreground" "$kitty_colors" | awk '{print $2}')
    black=$(grep "^color0 " "$kitty_colors" | awk '{print $2}')
    gray=$(grep "^color8 " "$kitty_colors" | awk '{print $2}')
    red=$(grep "^color1 " "$kitty_colors" | awk '{print $2}')
    green=$(grep "^color2 " "$kitty_colors" | awk '{print $2}')
    yellow=$(grep "^color3 " "$kitty_colors" | awk '{print $2}')
    blue=$(grep "^color4 " "$kitty_colors" | awk '{print $2}')
    magenta=$(grep "^color5 " "$kitty_colors" | awk '{print $2}')
    cyan=$(grep "^color6 " "$kitty_colors" | awk '{print $2}')
    white=$(grep "^color7 " "$kitty_colors" | awk '{print $2}')
    bright_white=$(grep "^color15" "$kitty_colors" | awk '{print $2}')
    
    # Create rofi directory
    mkdir -p "$rofi_dir"
    
    # Generate rofi colors based on Material Design 3 principles
    cat > "$rofi_colors" << EOF
* {
    /* Primary accent color (using cyan/green as primary) */
    primary: ${cyan};
    primary-container: ${blue};
    on-primary: ${black};
    on-primary-container: ${bright_white};
    
    /* Secondary accent */
    secondary: ${magenta};
    secondary-container: ${gray};
    on-secondary: ${black};
    on-secondary-container: ${fg};
    
    /* Surface backgrounds (progressively lighter) */
    surface: ${black};
    surface-dim: ${black};
    surface-bright: ${gray};
    surface-container-lowest: ${black};
    surface-container-low: ${black};
    surface-container: ${gray};
    surface-container-high: ${gray};
    surface-container-highest: ${gray};
    
    /* Text colors */
    on-surface: ${bright_white};
    on-surface-variant: ${white};
    
    /* Outline/border colors */
    outline: ${gray};
    outline-variant: ${gray};
    
    /* Error colors */
    error: ${red};
    on-error: ${black};
    
    /* Inverse colors */
    inverse-surface: ${fg};
    inverse-on-surface: ${bg};
}
EOF
    
    echo "✓ Created rofi colors for $theme"
}

echo "Creating rofi color configs for all themes..."
echo ""

# Process all themes
for theme_dir in "$THEMES_DIR"/*; do
    if [ -d "$theme_dir" ]; then
        theme=$(basename "$theme_dir")
        create_rofi_colors "$theme"
    fi
done

echo ""
echo "Done! Rofi colors created for all themes."
echo ""
echo "To apply: Switch theme using ~/themes/switch-theme.sh"
