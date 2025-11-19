#!/usr/bin/env bash

# Generate vesktop themes for all static (non-matugen) themes
# Preserves original theme colors but ensures proper contrast

THEMES_DIR="$HOME/dotfiles/themes"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color manipulation functions
hex_to_rgb() {
    local hex="${1#\#}"
    printf "%d %d %d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

rgb_to_hex() {
    printf "#%02x%02x%02x" "$1" "$2" "$3"
}

# Adjust brightness while preserving hue/saturation
adjust_brightness() {
    local hex="$1"
    local adjustment="$2"  # positive = lighter, negative = darker
    
    read -r r g b <<< "$(hex_to_rgb "$hex")"
    
    # Apply brightness adjustment
    r=$((r + adjustment))
    g=$((g + adjustment))
    b=$((b + adjustment))
    
    # Clamp to 0-255
    r=$((r < 0 ? 0 : r > 255 ? 255 : r))
    g=$((g < 0 ? 0 : g > 255 ? 255 : g))
    b=$((b < 0 ? 0 : b > 255 ? 255 : b))
    
    rgb_to_hex "$r" "$g" "$b"
}

# Extract color from alacritty.toml (handles both normal and bright colors)
extract_alacritty_color() {
    local file="$1"
    local key="$2"
    
    # Try normal colors first
    local color=$(grep "^$key = " "$file" 2>/dev/null | head -1 | sed "s/$key = //g" | tr -d "'\" ")
    
    # If not found, try bright colors section
    if [[ -z "$color" ]]; then
        color=$(awk -v key="$key" '/\[colors\.bright\]/,/^$/ { if ($1 == key) { gsub(/[^#a-fA-F0-9]/, "", $3); print $3 } }' "$file" 2>/dev/null | head -1)
    fi
    
    echo "$color"
}

# Extract color from btop.theme
extract_btop_color() {
    local file="$1"
    local key="$2"
    grep "^theme\[$key\]=" "$file" 2>/dev/null | sed 's/.*="\(.*\)"/\1/' | tr -d '"'
}

# Generate vesktop theme for a single theme
generate_theme() {
    local theme_name="$1"
    local theme_dir="$THEMES_DIR/$theme_name"
    
    # Skip if theme doesn't exist or is matugen
    if [[ ! -d "$theme_dir" || "$theme_name" == "matugen" ]]; then
        return
    fi
    
    echo "Generating vesktop theme for: $theme_name"
    
    # Extract colors from alacritty
    local alacritty_file="$theme_dir/.config/alacritty/colors.toml"
    local btop_file="$theme_dir/.config/btop/themes/current.theme"
    
    if [[ ! -f "$alacritty_file" || ! -f "$btop_file" ]]; then
        echo "  ⚠ Missing color files for $theme_name, skipping..."
        return
    fi
    
    # Get base colors from alacritty
    local bg=$(extract_alacritty_color "$alacritty_file" "background")
    local fg=$(extract_alacritty_color "$alacritty_file" "foreground")
    
    # Get accent colors from alacritty bright palette
    local bright_blue=$(grep -A 10 "\[colors.bright\]" "$alacritty_file" | grep "^blue = " | sed "s/blue = //g" | tr -d "'\" ")
    local bright_magenta=$(grep -A 10 "\[colors.bright\]" "$alacritty_file" | grep "^magenta = " | sed "s/magenta = //g" | tr -d "'\" ")
    local bright_cyan=$(grep -A 10 "\[colors.bright\]" "$alacritty_file" | grep "^cyan = " | sed "s/cyan = //g" | tr -d "'\" ")
    
    # Get btop colors (these match the theme vibe perfectly)
    local btop_main_fg=$(extract_btop_color "$btop_file" "main_fg")
    local btop_hi_fg=$(extract_btop_color "$btop_file" "hi_fg")
    local btop_selected_bg=$(extract_btop_color "$btop_file" "selected_bg")
    local btop_div_line=$(extract_btop_color "$btop_file" "div_line")
    
    # Use btop hi_fg as primary accent (matches theme perfectly)
    local primary="${btop_hi_fg:-$bright_blue}"
    
    # Background hierarchy with GOOD CONTRAST
    # bg-4 (main/darkest) must be significantly darker than bg-3 (cards)
    local bg_4="$bg"                                    # Main background (darkest)
    local bg_3=$(adjust_brightness "$bg" 30)            # Cards/secondary (GOOD contrast: +30)
    local bg_2=$(adjust_brightness "$bg" 45)            # Buttons (even lighter)
    local bg_1=$(adjust_brightness "$bg" 10)            # Clicked state
    local hover=$(adjust_brightness "$bg" 45)           # Hover state
    local active="${btop_selected_bg:-$(adjust_brightness "$bg" 55)}"  # Use btop selected or lighter
    local message_hover=$(adjust_brightness "$bg" 45)   # Message hover
    
    # Accent variations (use theme colors)
    local accent_container=$(adjust_brightness "$primary" -50)  # Darker container
    local accent_dim=$(adjust_brightness "$primary" -25)        # Dimmed
    
    # Text hierarchy (use theme colors)
    local text_0=$(adjust_brightness "$bg" -200)      # Text on colored elements (very dark)
    local text_1="${btop_main_fg:-$fg}"               # Primary text (use btop for visibility)
    local text_2="${btop_main_fg:-$fg}"               # Headings
    local text_3="${btop_main_fg:-$fg}"               # Normal text
    local text_4=$(adjust_brightness "${btop_main_fg:-$fg}" -40)  # Secondary text
    local text_5="${btop_div_line:-$(adjust_brightness "$fg" -70)}"  # Muted text
    
    # Status indicators from alacritty bright colors
    local bright_green=$(grep -A 10 "\[colors.bright\]" "$alacritty_file" | grep "^green = " | sed "s/green = //g" | tr -d "'\" ")
    local bright_red=$(grep -A 10 "\[colors.bright\]" "$alacritty_file" | grep "^red = " | sed "s/red = //g" | tr -d "'\" ")
    local bright_yellow=$(grep -A 10 "\[colors.bright\]" "$alacritty_file" | grep "^yellow = " | sed "s/yellow = //g" | tr -d "'\" ")
    
    local online="${bright_green:-#23a55a}"
    local dnd="${bright_red:-#f13f43}"
    local idle="${bright_yellow:-#f0b232}"
    local streaming="${bright_magenta:-#593695}"
    
    # Create output directory
    local output_dir="$theme_dir/.config/vesktop/themes"
    mkdir -p "$output_dir"
    
    # Generate the CSS file
    cat > "$output_dir/midnight-discord.css" <<EOF
/**
 * @name midnight
 * @description A dark, rounded discord theme.
 * @author refact0r
 * @version 1.6.2
 * @invite nz87hXyvcy
 * @website https://github.com/refact0r/midnight-discord
 * @source https://github.com/refact0r/midnight-discord/blob/master/midnight.theme.css
 * @authorId 508863359777505290
 * @authorLink https://www.refact0r.dev
 */

/* IMPORTANT: make sure to enable dark mode in discord settings for the theme to apply properly!!! */

@import url('https://refact0r.github.io/midnight-discord/build/midnight.css');

/* customize things here */
:root {
  /* font, change to 'gg sans' for default discord font*/
  --font: 'figtree';

  /* top left corner text */
  --corner-text: 'Midnight';

  /* color of status indicators and window controls */
  --online-indicator: $online; /* online status */
  --dnd-indicator: $dnd; /* do not disturb */
  --idle-indicator: $idle; /* idle/away */
  --streaming-indicator: $streaming; /* streaming */

  /* accent colors */
  --accent-1: $primary; /* links */
  --accent-2: $primary; /* general unread/mention elements, some icons when active */
  --accent-3: $primary; /* accent buttons */
  --accent-4: $accent_container; /* accent buttons when hovered */
  --accent-5: $accent_dim; /* accent buttons when clicked */
  --mention: $accent_container; /* mentions & mention messages */
  --mention-hover: $accent_dim; /* mentions & mention messages when hovered */

  /* text colors */
  --text-0: $text_0; /* text on colored elements */
  --text-1: $text_1; /* other normally white text */
  --text-2: $text_2; /* headings and important text */
  --text-3: $text_3; /* normal text */
  --text-4: $text_4; /* icon buttons and channels */
  --text-5: $text_5; /* muted channels/chats and timestamps */

  /* background and dark colors */
  --bg-1: $bg_1; /* dark buttons when clicked */
  --bg-2: $bg_2; /* dark buttons */
  --bg-3: $bg_3; /* spacing, secondary elements */
  --bg-4: $bg_4; /* main background color */
  --hover: $hover; /* channels and buttons when hovered */
  --active: $active; /* channels and buttons when clicked or selected */
  --message-hover: $hover; /* messages when hovered */

  /* amount of spacing and padding */
  --spacing: 12px;

  /* animations */
  /* ALL ANIMATIONS CAN BE DISABLED WITH REDUCED MOTION IN DISCORD SETTINGS */
  --list-item-transition: 0.2s ease;
  /* channels/members/settings hover transition */
  --unread-bar-transition: 0.2s ease;
  /* unread bar moving into view transition */
  --moon-spin-transition: 0.4s ease;
  /* moon icon spin */
  --icon-spin-transition: 1s ease;
  /* round icon button spin (settings, emoji, etc.) */

  /* corner roundness (border-radius) */
  --roundness-xl: 22px;
  /* roundness of big panel outer corners */
  --roundness-l: 20px;
  /* popout panels */
  --roundness-m: 16px;
  /* smaller panels, images, embeds */
  --roundness-s: 12px;
  /* members, settings inputs */
  --roundness-xs: 10px;
  /* channels, buttons */
  --roundness-xxs: 8px;
  /* searchbar, small elements */

  /* direct messages moon icon */
  /* change to block to show, none to hide */
  --discord-icon: none;
  /* discord icon */
  --moon-icon: block;
  /* moon icon */
  --moon-icon-url: url('https://upload.wikimedia.org/wikipedia/commons/c/c4/Font_Awesome_5_solid_moon.svg');
  /* custom icon url */
  --moon-icon-size: auto;

  /* filter uncolorable elements to fit theme */
  /* (just set to none, they're too much work to configure) */
  --login-bg-filter: saturate(0.3) hue-rotate(-15deg) brightness(0.4);
  /* login background artwork */
  --green-to-accent-3-filter: hue-rotate(56deg) saturate(1.43);
  /* add friend page explore icon */
  --blurple-to-accent-3-filter: hue-rotate(304deg) saturate(0.84) brightness(1.2);
  /* add friend page school icon */
}

/* Selected chat/friend text */
.selected_f5eb4b,
.selected_f6f816 .link_d8bfb3 {
  color: var(--text-0) !important;
  background: var(--accent-3) !important;
}

.selected_f6f816 .link_d8bfb3 * {
  color: var(--text-0) !important;
  fill: var(--text-0) !important;
}
EOF

    echo "  ✓ Generated: $output_dir/midnight-discord.css"
}

# Main execution
main() {
    echo "════════════════════════════════════════════════════════════"
    echo "  Vesktop Theme Generator"
    echo "  Generating matching themes with proper contrast"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    
    # Get all themes (excluding matugen)
    local themes=(
        "void"
        "tokyo-night"
        "zen"
        "aamis"
        "carnage"
        "sakura"
        "forest"
        "rose-pine"
        "gruvbox-material"
    )
    
    for theme in "${themes[@]}"; do
        generate_theme "$theme"
    done
    
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  ✓ Done! Generated vesktop themes for ${#themes[@]} themes"
    echo "════════════════════════════════════════════════════════════"
}

main "$@"
