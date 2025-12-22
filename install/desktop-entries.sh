#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Desktop Entries     |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$DOTFILES/.local/share/applications"
TARGET_DIR="$HOME/.local/share/applications"

step "Setting up desktop entries"

mkdir -p "$TARGET_DIR"

# Browser overrides (skip if stow already linked them)
if command -v brave &>/dev/null && [[ -f "$APPS_DIR/brave-browser.desktop" ]]; then
    if [[ ! -L "$TARGET_DIR/brave-browser.desktop" ]]; then
        cp -f "$APPS_DIR/brave-browser.desktop" "$TARGET_DIR/"
    fi
    ok "Brave override"
fi

if command -v chromium &>/dev/null && [[ -f "$APPS_DIR/chromium.desktop" ]]; then
    if [[ ! -L "$TARGET_DIR/chromium.desktop" ]]; then
        cp -f "$APPS_DIR/chromium.desktop" "$TARGET_DIR/"
    fi
    ok "Chromium override"
fi

# Hide system clutter (LSP plugins, electron, etc)
if [[ -x "$DOTFILES/scripts/hide-apps" ]]; then
    count=$("$DOTFILES/scripts/hide-apps" 2>/dev/null | grep -oP '\d+' || echo 0)
    if [[ $count -gt 0 ]]; then
        ok "Hidden $count system apps"
    fi
fi

# Web apps (optional) - only show capitalized names (our custom web apps)
if command -v gum &>/dev/null; then
    webapps=()
    for file in "$APPS_DIR"/*.desktop; do
        [[ -f "$file" ]] || continue
        name=$(basename "$file" .desktop)
        # Skip browser overrides and system files (lowercase names)
        case "$name" in 
            brave-browser|chromium|grub-customizer) continue ;;
        esac
        # Only include capitalized names (web apps we created)
        [[ "$name" =~ ^[A-Z] ]] && webapps+=("$name")
    done

    if [[ ${#webapps[@]} -gt 0 ]]; then
        echo
        if gum confirm "Install web apps?"; then
            selected=$(printf '%s\n' "${webapps[@]}" | gum choose --no-limit --height 15) || true
            for app in $selected; do
                [[ -n "$app" ]] && cp --remove-destination "$APPS_DIR/$app.desktop" "$TARGET_DIR/" && ok "$app"
            done
        fi
    fi
fi

# Refresh
update-desktop-database "$TARGET_DIR" 2>/dev/null || true
rm -f "$HOME/.cache/rofi"* 2>/dev/null || true
true
