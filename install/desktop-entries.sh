#!/bin/bash
# Desktop apps setup (webapps, hidden entries)

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$DOTFILES/.local/share/applications"
TARGET_DIR="$HOME/.local/share/applications"

# ─────────────────────────────────────────────────────────────────────────────
# Web Apps (personal, users choose which ones)
# ─────────────────────────────────────────────────────────────────────────────

ask_webapps() {
    command -v gum &>/dev/null || return

    # Collect webapp names (skip browser config overrides)
    local webapps=()
    for file in "$APPS_DIR"/*.desktop; do
        [[ -f "$file" ]] || continue
        local name=$(basename "$file" .desktop)
        case "$name" in
            brave-browser|chromium|grub-customizer) continue ;;
        esac
        webapps+=("$name")
    done

    [[ ${#webapps[@]} -eq 0 ]] && return

    echo
    gum confirm "Install web apps?" || return

    step "Select web apps"
    local selected=$(printf '%s\n' "${webapps[@]}" | gum choose --no-limit --height 15)

    [[ -z "$selected" ]] && return

    mkdir -p "$TARGET_DIR"
    for app in $selected; do
        cp "$APPS_DIR/$app.desktop" "$TARGET_DIR/"
        ok "$app"
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# Hidden Apps (hide unwanted entries from launcher)
# ─────────────────────────────────────────────────────────────────────────────

setup_hidden() {
    [[ -d "$APPS_DIR/hidden" ]] || return

    mkdir -p "$TARGET_DIR"
    local count=0

    for file in "$APPS_DIR/hidden"/*.desktop; do
        [[ -f "$file" ]] || continue
        cp "$file" "$TARGET_DIR/"
        ((count++))
    done

    [[ $count -gt 0 ]] && ok "Hidden $count apps from launcher"
}

# ─────────────────────────────────────────────────────────────────────────────
# Run
# ─────────────────────────────────────────────────────────────────────────────

ask_webapps
setup_hidden

# Refresh desktop database
command -v update-desktop-database &>/dev/null && update-desktop-database "$TARGET_DIR" 2>/dev/null
rm -f "$HOME/.cache/rofi3.druncache" 2>/dev/null
