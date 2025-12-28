#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Desktop Entries     |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$DOTFILES/.local/share/applications"
TARGET_DIR="$HOME/.local/share/applications"

step "Setting up desktop entries"

# If stow symlinked the whole directory, remove it
if [[ -L "$TARGET_DIR" ]]; then
    rm "$TARGET_DIR"
    info "Removed stale symlink"
fi

mkdir -p "$TARGET_DIR"

# Browser overrides
if command -v brave &>/dev/null && [[ -f "$APPS_DIR/brave-browser.desktop" ]]; then
    cat "$APPS_DIR/brave-browser.desktop" > "$TARGET_DIR/brave-browser.desktop"
    ok "Brave override"
fi

if command -v chromium &>/dev/null && [[ -f "$APPS_DIR/chromium.desktop" ]]; then
    cat "$APPS_DIR/chromium.desktop" > "$TARGET_DIR/chromium.desktop"
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
                if [[ -n "$app" ]]; then
                    # Replace hardcoded /home/vyrx with user's $HOME
                    sed "s|/home/vyrx|$HOME|g" "$APPS_DIR/$app.desktop" > "$TARGET_DIR/$app.desktop"
                    ok "$app"
                fi
            done
        fi
    fi
fi

# Refresh desktop database
update-desktop-database "$TARGET_DIR" 2>/dev/null || true
rm -f "$HOME/.cache/rofi"* 2>/dev/null || true
