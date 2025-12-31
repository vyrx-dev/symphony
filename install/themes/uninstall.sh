#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Theme Uninstaller   |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$DOTFILES_ROOT/install/utils.sh"

THEMES_DIR="$DOTFILES_ROOT/themes"
SYMPHONY_DIR="$HOME/.config/symphony"

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Functions                                                             │
# ╰───────────────────────────────────────────────────────────────────────╯

show_menu() {
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
    echo "$choice"
}

delete_themes() {
    local themes=()

    for dir in "$THEMES_DIR"/*; do
        [[ -d "$dir" ]] && themes+=("$(basename "$dir")")
    done

    [[ ${#themes[@]} -eq 0 ]] && { info "No themes found"; return 0; }

    local selected=""
    if [[ $HAS_GUM -eq 1 ]]; then
        info "Space to select, Enter to confirm"
        selected=$(printf '%s\n' "${themes[@]}" | gum choose --no-limit) || return 0
    else
        echo
        info "Available themes:"
        for i in "${!themes[@]}"; do
            echo "    $((i+1))) ${themes[$i]}"
        done
        echo
        read -rp "  Enter numbers (space-separated): " nums

        for num in $nums; do
            local idx=$((num-1))
            [[ $idx -ge 0 && $idx -lt ${#themes[@]} ]] && selected+="${themes[$idx]}"$'\n'
        done
    fi

    [[ -z "$selected" ]] && { info "Nothing selected"; return 0; }

    echo
    warn "Will delete:"
    echo "$selected" | while read -r t; do [[ -n "$t" ]] && echo "    $t"; done
    echo

    confirm "Continue?" || return 0

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
    echo "  This will remove:"
    echo "    - Symphony config ($SYMPHONY_DIR)"
    echo "    - Legacy theme file (~/.current-theme)"
    echo "    - Pywal cache symlink"
    echo
    
    confirm "Continue?" || return 0
    
    echo
    read -rp "  Type 'yes' to confirm: " answer
    [[ "$answer" != "yes" ]] && { info "Cancelled"; return 0; }

    step "Removing"

    [[ -d "$SYMPHONY_DIR" ]] && rm -rf "$SYMPHONY_DIR" && ok "Symphony config"
    [[ -f "$HOME/.current-theme" ]] && rm -f "$HOME/.current-theme" && ok "Legacy theme file"
    [[ -L "$HOME/.cache/wal/colors.json" ]] && rm -f "$HOME/.cache/wal/colors.json" && ok "Pywal symlink"

    echo
    ok "Complete removal done"
    echo
    info "Manual cleanup:"
    info "  - Remove PATH entry from shell rc file"
    info "  - Reload shell: source ~/.bashrc or ~/.zshrc"

    return 0
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Main                                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

choice=$(show_menu)

case $choice in
    1) delete_themes ;;
    2) nuke_everything ;;
    3) info "Cancelled" ;;
    *) err "Invalid choice"; exit 1 ;;
esac
