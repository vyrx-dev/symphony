#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Theme Uninstaller   |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYMPHONY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SYMPHONY_ROOT/install/utils.sh"

THEMES_DIR="$SYMPHONY_ROOT/themes"
SYMPHONY_DIR="$HOME/.config/symphony"

delete_themes() {
    local themes=()

    for dir in "$THEMES_DIR"/*; do
        [[ -d "$dir" ]] && themes+=("$(basename "$dir")")
    done

    [[ ${#themes[@]} -eq 0 ]] && { info "No themes found"; return 0; }

    info "Space to select, Enter to confirm"
    local selected
    selected=$(printf '%s\n' "${themes[@]}" | gum choose --no-limit) || return 0

    [[ -z "$selected" ]] && { info "Nothing selected"; return 0; }

    echo
    warn "Will delete:"
    echo "$selected" | while read -r t; do [[ -n "$t" ]] && echo "    $t"; done
    echo

    gum confirm "Continue?" || return 0

    while IFS= read -r theme; do
        [[ -z "$theme" ]] && continue
        rm -rf "${THEMES_DIR:?}/$theme"
        ok "Deleted $theme"
    done <<< "$selected"

    return 0
}

nuke_everything() {
    echo
    warn "COMPLETE REMOVAL"
    echo
    echo "  The following will be removed:"
    echo
    echo "    Config:      $SYMPHONY_DIR"
    echo "    Legacy file: ~/.current-theme"
    echo "    Symlink:     ~/.cache/wal/colors.json"
    echo
    
    gum confirm "Continue?" || return 0
    
    echo
    read -rp "  Type 'yes' to confirm: " answer
    [[ "$answer" != "yes" ]] && { info "Cancelled"; return 0; }

    step "Removing Symphony"

    [[ -d "$SYMPHONY_DIR" ]] && rm -rf "$SYMPHONY_DIR" && ok "Removed config directory"
    [[ -f "$HOME/.current-theme" ]] && rm -f "$HOME/.current-theme" && ok "Removed legacy theme file"
    [[ -L "$HOME/.cache/wal/colors.json" ]] && rm -f "$HOME/.cache/wal/colors.json" && ok "Removed pywal symlink"

    ok "Uninstall complete"
    echo
    info "Manual cleanup required:"
    info "  - Remove PATH entry from your shell config:"
    info "      Fish:  ~/.config/fish/config.fish"
    info "      Bash:  ~/.bashrc"
    info "      Zsh:   ~/.zshrc"
    echo
    info "  - Then reload your shell"

    return 0
}

# Main
clear
echo
show_banner
echo
warn "Theme Uninstaller"
echo
echo "  1) Delete specific themes"
echo "  2) Complete removal"
echo "  3) Cancel"
echo

read -rp "  Select: " choice

case "$choice" in
    1) delete_themes ;;
    2) nuke_everything ;;
    3) info "Cancelled" ;;
    *) err "Invalid choice"; exit 1 ;;
esac
