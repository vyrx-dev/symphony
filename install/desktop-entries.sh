#!/bin/bash
# Desktop entries setup

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$DOTFILES/.local/share/applications"
TARGET_DIR="$HOME/.local/share/applications"

step "Setting up desktop entries"

mkdir -p "$TARGET_DIR"

# Browser overrides (only if browser installed)
command -v brave &>/dev/null && [[ -f "$APPS_DIR/brave-browser.desktop" ]] && {
    cp "$APPS_DIR/brave-browser.desktop" "$TARGET_DIR/"
    ok "brave override"
}

command -v chromium &>/dev/null && [[ -f "$APPS_DIR/chromium.desktop" ]] && {
    cp "$APPS_DIR/chromium.desktop" "$TARGET_DIR/"
    ok "chromium override"
}

# Hidden apps
if [[ -d "$APPS_DIR/hidden" ]]; then
    n=0
    for file in "$APPS_DIR/hidden"/*.desktop; do
        [[ -f "$file" ]] || continue
        cp "$file" "$TARGET_DIR/"
        ((n++)) || true
    done
    [[ $n -gt 0 ]] && ok "Hidden $n apps"
fi

# Web apps (gum prompt)
if command -v gum &>/dev/null; then
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
command -v update-desktop-database &>/dev/null && update-desktop-database "$TARGET_DIR" 2>/dev/null
rm -f "$HOME/.cache/rofi3.druncache" 2>/dev/null
true
