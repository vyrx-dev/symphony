#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Installer           |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES/install/utils.sh"

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
for dep in git stow; do
    pkg_installed "$dep" && ok "$dep" || { err "$dep"; missing+=("$dep"); }
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo
    err "Missing: ${missing[*]}"
    info "Run: sudo pacman -S ${missing[*]}"
    exit 1
fi

# Install packages
source "$DOTFILES/install/packages.sh"

# Symlink dotfiles
source "$DOTFILES/install/stow.sh"

# Setup desktop entries
source "$DOTFILES/install/desktop-entries.sh"

# Enable user services
source "$DOTFILES/install/services.sh"

# Choose default shell
echo
"$DOTFILES/scripts/choose-shell"

# Remove any stale first-run marker (fresh installs should run first-run)
rm -f ~/.local/state/symphony/first-run-done

# Install themes (skip logo since we already showed banner)
SYMPHONY_INSTALLING=1 "$DOTFILES/install/themes/install.sh"

# Done
echo
ok "Installation complete"
info "Log out and back in for changes to take effect"
info "Run 'symphony help' to get started"
echo
