#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Installer           |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

SYMPHONY_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SYMPHONY_DIR/install/utils.sh"

# Banner
clear
show_banner
echo

# Existing install warning
[[ -d "$HOME/.config/symphony" ]] && warn "Existing installation detected"

warn "This will install packages and modify your configs."
echo
confirm "Continue?" || exit 0

# Check core dependencies
step "Checking dependencies"
missing=()
for dep in git; do
    pkg_installed "$dep" && ok "$dep" || { err "$dep"; missing+=("$dep"); }
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo
    err "Missing: ${missing[*]}"
    info "Run: sudo pacman -S ${missing[*]}"
    exit 1
fi

# Install packages
source "$SYMPHONY_DIR/install/packages.sh"

# Deploy configs
source "$SYMPHONY_DIR/install/deploy.sh"

# Setup desktop entries
source "$SYMPHONY_DIR/install/desktop-entries.sh"

# Enable user services
source "$SYMPHONY_DIR/install/services.sh"

# Choose default shell
echo
"$SYMPHONY_DIR/bin/choose-shell"

# Clear first-run markers (fresh installs should go through all stages)
rm -f ~/.local/state/symphony/themes-installed
rm -f ~/.local/state/symphony/first-run-done

# Optional post-install setup
source "$SYMPHONY_DIR/install/post-setup.sh"

# Done
echo
ok "Installation complete"
info "Log out and back in — themes will be set up on first login"
info "Run 'symphony help' to get started"
echo
