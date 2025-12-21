#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Pre-flight Checks   |--/ /-|#
#|-/ /--| Symphony Dotfiles   |-/ /--|#
#|/ /---+---------------------+/ /---|#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"

check_dependencies() {
    step "Checking dependencies"
    
    local missing=()
    
    # Required
    for dep in stow git; do
        if command -v "$dep" &>/dev/null; then
            ok "$dep"
        else
            err "$dep (required)"
            missing+=("$dep")
        fi
    done
    
    # Need at least one terminal
    local has_term=0
    for term in kitty ghostty alacritty; do
        if command -v "$term" &>/dev/null; then
            ok "$term"
            has_term=1
            break
        fi
    done
    [[ $has_term -eq 0 ]] && err "terminal (kitty/ghostty/alacritty)" && missing+=("kitty")
    
    # Optional but recommended
    for dep in hyprctl swww waybar rofi; do
        if command -v "$dep" &>/dev/null; then
            ok "$dep"
        else
            info "$dep (optional)"
        fi
    done
    
    # Bail if missing required
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo
        err "Missing required dependencies:"
        for dep in "${missing[@]}"; do
            info "  sudo pacman -S $dep"
        done
        exit 1
    fi
}

check_existing() {
    if [[ -d "$HOME/.config/symphony" ]]; then
        warn "Existing installation detected"
        info "This will update your configuration"
    fi
}

preflight() {
    clear
    show_banner
    info "A theme system that flows like music"
    echo
    check_existing
    
    warn "This will install packages and modify your configs."
    echo
    confirm "Continue with installation?" || exit 0
    
    check_dependencies
}

preflight
