#!/bin/bash

# Theme System Installer
# Sets up the complete theme switching system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$DOTFILES/themes"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Theme System Installer             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check required applications
echo -e "${YELLOW}→${NC} Checking required applications..."

REQUIRED=(
    "stow:GNU Stow (symlink manager)"
    "hyprctl:Hyprland compositor"
    "rofi:Application launcher"
    "swww:Wallpaper daemon"
)

MISSING=()
for app_info in "${REQUIRED[@]}"; do
    app="${app_info%%:*}"
    desc="${app_info#*:}"
    if ! command -v "$app" &> /dev/null; then
        MISSING+=("  ✗ $app - $desc")
    else
        echo -e "  ${GREEN}✓${NC} $app"
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}✗ Missing required applications:${NC}"
    printf '%s\n' "${MISSING[@]}"
    echo ""
    echo -e "${YELLOW}Install missing apps and run again.${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} All required applications found"
echo ""

# Detect optional apps
echo -e "${YELLOW}→${NC} Detecting optional applications..."
OPTIONAL=(
    "kitty:Terminal emulator"
    "alacritty:Terminal emulator"
    "waybar:Status bar"
    "btop:System monitor"
    "cava:Audio visualizer"
)

FOUND=()
for app_info in "${OPTIONAL[@]}"; do
    app="${app_info%%:*}"
    if command -v "$app" &> /dev/null; then
        FOUND+=("$app")
        echo -e "  ${GREEN}✓${NC} $app"
    fi
done

if [ ${#FOUND[@]} -eq 0 ]; then
    echo -e "  ${YELLOW}⚠${NC} No optional apps detected (theming will be limited)"
else
    echo -e "${GREEN}✓${NC} Found ${#FOUND[@]} optional app(s)"
fi
echo ""

# Create config directories
echo -e "${YELLOW}→${NC} Creating config directories..."
mkdir -p "$HOME/.config/hypr/theme"
mkdir -p "$HOME/.config/rofi"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/btop/themes"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/cava"
mkdir -p "$HOME/.config/rmpc/themes"
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"
mkdir -p "$HOME/.config/vesktop/themes"
mkdir -p "$HOME/.config/yazi"
mkdir -p "$HOME/.config/nvim/lua/plugins"
mkdir -p "$HOME/.cache/wal"
echo -e "${GREEN}✓${NC} Config directories created"
echo ""

# Make scripts executable
echo -e "${YELLOW}→${NC} Setting up scripts..."
chmod +x "$SCRIPT_DIR/theme"
chmod +x "$SCRIPT_DIR/core"/*.sh
chmod +x "$SCRIPT_DIR/generators"/*.sh
chmod +x "$SCRIPT_DIR/utils"/*.sh 2>/dev/null || true
echo -e "${GREEN}✓${NC} Scripts made executable"
echo ""

# Add to PATH if not already there
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "dotfiles/theme-scripts" "$SHELL_RC"; then
        echo -e "${YELLOW}→${NC} Adding theme command to PATH..."
        echo "" >> "$SHELL_RC"
        echo "# Theme system" >> "$SHELL_RC"
        echo 'export PATH="$HOME/dotfiles/theme-scripts:$PATH"' >> "$SHELL_RC"
        echo -e "${GREEN}✓${NC} Added to $SHELL_RC"
        echo -e "${YELLOW}  Run: source $SHELL_RC${NC}"
    else
        echo -e "${GREEN}✓${NC} Already in PATH"
    fi
fi
echo ""

# Count themes
THEME_COUNT=$(find "$THEMES_DIR" -maxdepth 1 -type d ! -name "themes" | wc -l)
THEME_COUNT=$((THEME_COUNT - 1))  # Exclude parent dir

echo -e "${YELLOW}→${NC} Found $THEME_COUNT theme(s)"
echo ""

# Generate theme configs
echo -e "${YELLOW}→${NC} Generating theme configurations..."
echo -e "  ${BLUE}This may take a moment...${NC}"
"$SCRIPT_DIR/generators/create-complete-starship.sh" >/dev/null 2>&1 || echo -e "  ${YELLOW}⚠${NC} Starship generation had issues"
"$SCRIPT_DIR/generators/create-cava-configs.sh" >/dev/null 2>&1 || echo -e "  ${YELLOW}⚠${NC} Cava generation had issues"
"$SCRIPT_DIR/generators/create-rmpc-themes.sh" >/dev/null 2>&1 || echo -e "  ${YELLOW}⚠${NC} RMPC generation had issues"
"$SCRIPT_DIR/generators/create-rofi-colors.sh" >/dev/null 2>&1 || echo -e "  ${YELLOW}⚠${NC} Rofi generation had issues"
"$SCRIPT_DIR/generators/create-yazi-themes.sh" >/dev/null 2>&1 || echo -e "  ${YELLOW}⚠${NC} Yazi generation had issues"
echo -e "${GREEN}✓${NC} Theme configs generated"
echo ""

# Set default theme
if [ ! -f "$HOME/.current-theme" ]; then
    echo -e "${YELLOW}→${NC} Setting default theme..."
    
    # Check if zen theme exists, otherwise use first available
    if [ -d "$THEMES_DIR/zen" ]; then
        echo "zen" > "$HOME/.current-theme"
        echo -e "${GREEN}✓${NC} Default theme: zen"
    elif [ -d "$THEMES_DIR/matugen" ]; then
        echo "matugen" > "$HOME/.current-theme"
        echo -e "${GREEN}✓${NC} Default theme: matugen"
    else
        # Get first theme
        FIRST_THEME=$(find "$THEMES_DIR" -maxdepth 1 -type d ! -name "themes" -exec basename {} \; | head -1)
        if [ -n "$FIRST_THEME" ] && [ "$FIRST_THEME" != "themes" ]; then
            echo "$FIRST_THEME" > "$HOME/.current-theme"
            echo -e "${GREEN}✓${NC} Default theme: $FIRST_THEME"
        fi
    fi
    echo ""
fi

# Apply current theme
CURRENT_THEME=$(cat "$HOME/.current-theme" 2>/dev/null || echo "zen")
echo -e "${YELLOW}→${NC} Applying theme: $CURRENT_THEME..."

cd "$THEMES_DIR"
if [ -d "$CURRENT_THEME" ]; then
    stow "$CURRENT_THEME" 2>/dev/null || true
    "$SCRIPT_DIR/core/fix-symlinks.sh" >/dev/null 2>&1
    echo -e "${GREEN}✓${NC} Theme applied"
else
    echo -e "${YELLOW}⚠${NC} Theme directory not found, skipping"
fi
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Installation Complete!           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓${NC} Theme system installed"
echo -e "${GREEN}✓${NC} Themes found: $THEME_COUNT"
echo -e "${GREEN}✓${NC} Current theme: $CURRENT_THEME"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo -e "  ${GREEN}theme switch${NC}        Switch themes"
echo -e "  ${GREEN}theme fix${NC}           Fix broken symlinks"
echo -e "  ${GREEN}theme generate-all${NC}  Regenerate configs"
echo -e "  ${GREEN}theme help${NC}          Show all commands"
echo ""
echo -e "${YELLOW}Add keybind to Hyprland:${NC}"
echo -e "  ${BLUE}bind = SUPER, T, exec, theme switch${NC}"
echo ""
echo -e "${BLUE}Enjoy your themes!${NC}"
