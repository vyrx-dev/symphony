#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Installer           |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

# Handle unknown terminal types (SSH from modern terminals)
if [[ -n "$TERM" ]] && ! tput longname &>/dev/null; then
	export TERM=xterm-256color
fi

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

# Set fish as default shell
if command -v fish &>/dev/null; then
    sudo chsh -s "$(command -v fish)" "$USER" && ok "Shell set to fish" || warn "Failed to set shell"
fi

# Note: first-run markers are preserved to prevent double theme install
# The theme installer will run once on first Hyprland login

# Optional post-install setup
source "$SYMPHONY_DIR/install/post-setup.sh"

# Reboot prompt
echo
ok "Installation complete"
echo
info "A reboot is required to finalize the setup."
info "Themes will be configured automatically when you first log in."
echo

if confirm "Reboot now?"; then
	ok "Rebooting..."
	sleep 2
	sudo reboot
else
	warn "Reboot skipped. Please restart manually to complete setup."
fi
