#!/bin/bash

# Symphony Theme System - Animated Installer
# Inspired by Omarchy's presentation style

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$DOTFILES/themes"
LOGO_PATH="$SCRIPT_DIR/symphony-logo.txt"

# Check if gum is available
if ! command -v gum &>/dev/null; then
    echo "This installer requires 'gum' for a beautiful experience"
    echo "Install with: sudo pacman -S gum"
    echo ""
    echo "Or run the basic installer: bash theme-scripts/install.sh"
    exit 1
fi

# Get terminal size for centering
if [ -e /dev/tty ]; then
    TERM_SIZE=$(stty size 2>/dev/null </dev/tty)
    if [ -n "$TERM_SIZE" ]; then
        TERM_WIDTH=$(echo "$TERM_SIZE" | cut -d' ' -f2)
    else
        TERM_WIDTH=80
    fi
else
    TERM_WIDTH=80
fi

# Calculate logo centering
LOGO_WIDTH=$(awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 70)
PADDING_LEFT=$((($TERM_WIDTH - $LOGO_WIDTH) / 2))
PADDING_LEFT=$((PADDING_LEFT > 0 ? PADDING_LEFT : 0))

# Gum styling (Tokyo Night inspired)
export GUM_SPIN_SPINNER="dot"
export GUM_SPIN_SPINNER_FOREGROUND="6"  # Cyan
export GUM_SPIN_TITLE_FOREGROUND="7"    # White
export GUM_CONFIRM_PROMPT_FOREGROUND="6"
export GUM_CONFIRM_SELECTED_BACKGROUND="2"  # Green
export GUM_CONFIRM_SELECTED_FOREGROUND="0"  # Black

# Show logo
show_logo() {
    clear
    gum style --foreground 5 --padding "2 0 1 $PADDING_LEFT" "$(<"$LOGO_PATH")"
}

show_logo

# Check required applications
gum spin --title "Checking dependencies..." -- sleep 0.5

REQUIRED=(
    "stow:GNU Stow"
    "hyprctl:Hyprland"
    "rofi:Rofi"
    "swww:SWWW"
)

MISSING=()
for app_info in "${REQUIRED[@]}"; do
    app="${app_info%%:*}"
    if ! command -v "$app" &> /dev/null; then
        MISSING+=("$app")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    gum style --foreground 1 --bold --padding "1 0 0 $PADDING_LEFT" "✗ Missing required applications: ${MISSING[*]}"
    echo ""
    exit 1
fi

gum style --foreground 2 --padding "0 0 0 $PADDING_LEFT" "✓ All dependencies found"

# Detect optional apps
OPTIONAL=("kitty" "alacritty" "waybar" "btop" "cava")
FOUND=()
for app in "${OPTIONAL[@]}"; do
    if command -v "$app" &> /dev/null; then
        FOUND+=("$app")
    fi
done

gum style --foreground 6 --padding "0 0 1 $PADDING_LEFT" "✓ Found ${#FOUND[@]} optional apps: ${FOUND[*]}"

# Create config directories
gum spin --title "Creating config directories..." -- bash -c "
    mkdir -p '$HOME/.config/hypr/theme'
    mkdir -p '$HOME/.config/rofi'
    mkdir -p '$HOME/.config/kitty'
    mkdir -p '$HOME/.config/alacritty'
    mkdir -p '$HOME/.config/btop/themes'
    mkdir -p '$HOME/.config/waybar'
    mkdir -p '$HOME/.config/cava'
    mkdir -p '$HOME/.config/rmpc/themes'
    mkdir -p '$HOME/.config/gtk-3.0'
    mkdir -p '$HOME/.config/gtk-4.0'
    mkdir -p '$HOME/.config/vesktop/themes'
    mkdir -p '$HOME/.config/yazi'
    mkdir -p '$HOME/.cache/wal'
"

# Make scripts executable
gum spin --title "Setting up scripts..." -- bash -c "
    chmod +x '$SCRIPT_DIR/symphony-theme' 2>/dev/null || chmod +x '$SCRIPT_DIR/theme'
    chmod +x '$SCRIPT_DIR/core'/*.sh
    chmod +x '$SCRIPT_DIR/generators'/*.sh
    chmod +x '$SCRIPT_DIR/utils'/*.sh 2>/dev/null || true
"

# Add to PATH
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "dotfiles/theme-scripts" "$SHELL_RC"; then
        gum spin --title "Adding to PATH..." -- bash -c "
            echo '' >> '$SHELL_RC'
            echo '# Symphony Theme System' >> '$SHELL_RC'
            echo 'export PATH=\"\$HOME/dotfiles/theme-scripts:\$PATH\"' >> '$SHELL_RC'
        "
        gum style --foreground 3 --padding "0 0 0 $PADDING_LEFT" "⚠ Remember to run: source $SHELL_RC"
    fi
fi

# Count themes
THEME_COUNT=$(find "$THEMES_DIR" -maxdepth 1 -type d ! -name "themes" 2>/dev/null | wc -l)
THEME_COUNT=$((THEME_COUNT - 1))

gum style --foreground 5 --padding "1 0 0 $PADDING_LEFT" "Found $THEME_COUNT theme(s)"

# Generate theme configs
gum style --foreground 6 --padding "0 0 0 $PADDING_LEFT" "Generating theme configurations..."

gum spin --title "  → Starship prompts..." -- "$SCRIPT_DIR/generators/create-complete-starship.sh" >/dev/null 2>&1 || true
gum spin --title "  → Cava visualizers..." -- "$SCRIPT_DIR/generators/create-cava-configs.sh" >/dev/null 2>&1 || true
gum spin --title "  → RMPC themes..." -- "$SCRIPT_DIR/generators/create-rmpc-themes.sh" >/dev/null 2>&1 || true
gum spin --title "  → Rofi colors..." -- "$SCRIPT_DIR/generators/create-rofi-colors.sh" >/dev/null 2>&1 || true
gum spin --title "  → Yazi themes..." -- "$SCRIPT_DIR/generators/create-yazi-themes.sh" >/dev/null 2>&1 || true

# Set default theme
if [ ! -f "$HOME/.current-theme" ]; then
    if [ -d "$THEMES_DIR/zen" ]; then
        echo "zen" > "$HOME/.current-theme"
        CURRENT_THEME="zen"
    elif [ -d "$THEMES_DIR/matugen" ]; then
        echo "matugen" > "$HOME/.current-theme"
        CURRENT_THEME="matugen"
    else
        FIRST_THEME=$(find "$THEMES_DIR" -maxdepth 1 -type d ! -name "themes" -exec basename {} \; | head -1)
        if [ -n "$FIRST_THEME" ] && [ "$FIRST_THEME" != "themes" ]; then
            echo "$FIRST_THEME" > "$HOME/.current-theme"
            CURRENT_THEME="$FIRST_THEME"
        fi
    fi
else
    CURRENT_THEME=$(cat "$HOME/.current-theme")
fi

# Apply theme
gum spin --title "Applying theme: $CURRENT_THEME..." -- bash -c "
    cd '$THEMES_DIR'
    stow '$CURRENT_THEME' 2>/dev/null || true
    '$SCRIPT_DIR/core/fix-symlinks.sh' >/dev/null 2>&1 || true
"

# Success!
sleep 0.3
show_logo

gum style \
    --foreground 2 \
    --bold \
    --border double \
    --border-foreground 2 \
    --padding "1 2" \
    --margin "0 0 0 $PADDING_LEFT" \
    --align center \
    --width 50 \
    "✓ INSTALLATION COMPLETE! ✓"

echo ""
gum style --padding "0 0 0 $PADDING_LEFT" "$(cat <<EOF
  Themes installed: $THEME_COUNT
  Active theme: $CURRENT_THEME

  Commands:
    symphony-theme switch        Switch themes
    symphony-theme list          Show all themes
    symphony-theme remove <name> Remove a theme
    symphony-theme fix           Fix symlinks
    symphony-theme generate-all  Regenerate configs

  Keyboard shortcuts:
    SUPER + T                    Switch themes
    SUPER + ALT + SPACE          Random wallpaper

  Manual wallpaper:
    swww img /path/to/image.jpg

  Enjoy your themes! 🎨
EOF
)"

echo ""
