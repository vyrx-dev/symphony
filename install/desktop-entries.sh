#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Desktop Entries     |-/ /--|#
#|/ /---+---------------------+/ /---|#

SYMPHONY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -z "$RESET" ]] && source "$SYMPHONY_DIR/install/utils.sh"
APPS_DIR="$SYMPHONY_DIR/local/share/applications"
TARGET_DIR="$HOME/.local/share/applications"

step "Setting up desktop entries"

# Remove stale symlink if present
if [[ -L "$TARGET_DIR" ]]; then
    rm "$TARGET_DIR"
fi

mkdir -p "$TARGET_DIR"
mkdir -p "$TARGET_DIR/icons"

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
if [[ -x "$SYMPHONY_DIR/bin/hide-apps" ]]; then
    count=$("$SYMPHONY_DIR/bin/hide-apps" 2>/dev/null | grep -oP '\d+' || echo 0)
    if [[ $count -gt 0 ]]; then
        ok "Hidden $count system apps"
    fi
fi

# Web apps (optional)
if command -v gum &>/dev/null; then
    echo
    if gum confirm "Install web apps?"; then
        source "$SYMPHONY_DIR/install/webapps.sh"
        install_webapps || true
    fi
fi

# Refresh desktop database
update-desktop-database "$TARGET_DIR" 2>/dev/null || true
rm -f "$HOME/.cache/rofi"* 2>/dev/null || true
