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
if [[ -x "$DOTFILES/scripts/hide-apps" ]]; then
    count=$("$DOTFILES/scripts/hide-apps" 2>/dev/null | grep -oP '\d+' || echo 0)
    if [[ $count -gt 0 ]]; then
        ok "Hidden $count system apps"
    fi
fi

# Web apps (optional)
if command -v gum &>/dev/null; then
    echo
    if gum confirm "Install web apps?"; then
        source "$DOTFILES/install/webapps.sh"
        install_webapps
    fi
fi

# Refresh desktop database
update-desktop-database "$TARGET_DIR" 2>/dev/null || true
rm -f "$HOME/.cache/rofi"* 2>/dev/null || true
