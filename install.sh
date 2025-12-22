#!/usr/bin/env bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Main Installer      |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

[[ -z "$BASH_VERSION" ]] && exec bash "$0" "$@"

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

chmod +x install/themes/install.sh install/themes/symphony scripts/* 2>/dev/null || true

source install/utils.sh

# ─────────────────────────────────────────────────────────────────────────────
# Welcome
# ─────────────────────────────────────────────────────────────────────────────

clear
echo
show_banner
info "A theme system that flows like music"
info "https://github.com/vyrx-dev/dotfiles"
echo

# Check existing
[[ -d "$HOME/.config/symphony" ]] && warn "Existing installation detected - configs will be updated"

warn "This will install packages and modify your configs."
echo
confirm "Continue?" || exit 0

# ─────────────────────────────────────────────────────────────────────────────
# Dependencies
# ─────────────────────────────────────────────────────────────────────────────

step "Checking dependencies"

missing=()
for dep in stow git; do
    command -v "$dep" &>/dev/null && ok "$dep" || { err "$dep"; missing+=("$dep"); }
done

has_term=0
for term in kitty ghostty alacritty; do
    command -v "$term" &>/dev/null && { ok "$term"; has_term=1; break; }
done
[[ $has_term -eq 0 ]] && { err "terminal (kitty/ghostty/alacritty)"; missing+=("kitty"); }

for dep in hyprctl swww waybar rofi gum; do
    command -v "$dep" &>/dev/null && ok "$dep" || info "$dep (optional)"
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo
    err "Install missing dependencies first:"
    for dep in "${missing[@]}"; do info "  sudo pacman -S $dep"; done
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Packages
# ─────────────────────────────────────────────────────────────────────────────

source install/packages.sh

# ─────────────────────────────────────────────────────────────────────────────
# Stow
# ─────────────────────────────────────────────────────────────────────────────

source install/stow.sh

# ─────────────────────────────────────────────────────────────────────────────
# Desktop entries
# ─────────────────────────────────────────────────────────────────────────────

source install/desktop-entries.sh

# ─────────────────────────────────────────────────────────────────────────────
# Themes
# ─────────────────────────────────────────────────────────────────────────────

"$DOTFILES/install/themes/install.sh" --skip-logo

# ─────────────────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────────────────

echo
ok "Installation complete!"
echo
info "Log out and back in for all changes to take effect."
info "Run 'symphony help' to get started."
echo
