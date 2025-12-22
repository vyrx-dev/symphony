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

# Browser overrides
command -v brave &>/dev/null && [[ -f "$APPS_DIR/brave-browser.desktop" ]] && {
    cp "$APPS_DIR/brave-browser.desktop" "$TARGET_DIR/"
    ok "Brave override"
}

command -v chromium &>/dev/null && [[ -f "$APPS_DIR/chromium.desktop" ]] && {
    cp "$APPS_DIR/chromium.desktop" "$TARGET_DIR/"
    ok "Chromium override"
}

# Hide system clutter (LSP plugins, electron, etc)
[[ -x "$DOTFILES/scripts/hide-apps" ]] && {
    count=$("$DOTFILES/scripts/hide-apps" 2>/dev/null | grep -oP '\d+' || echo 0)
    [[ $count -gt 0 ]] && ok "Hidden $count system apps"
}

# Web apps (optional)
if command -v gum &>/dev/null && [[ -d "$APPS_DIR" ]]; then
    webapps=()
    for file in "$APPS_DIR"/*.desktop; do
        [[ -f "$file" ]] || continue
        name=$(basename "$file" .desktop)
        case "$name" in brave-browser|chromium|grub-customizer) continue ;; esac
        webapps+=("$name")
    done

    if [[ ${#webapps[@]} -gt 0 ]]; then
        echo
        if gum confirm "Install web apps?"; then
            selected=$(printf '%s\n' "${webapps[@]}" | gum choose --no-limit --height 15)
            for app in $selected; do
                cp "$APPS_DIR/$app.desktop" "$TARGET_DIR/"
                ok "$app"
            done
        fi
    fi
fi

# Refresh
update-desktop-database "$TARGET_DIR" 2>/dev/null
rm -f "$HOME/.cache/rofi"* 2>/dev/null
