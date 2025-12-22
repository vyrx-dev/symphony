#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Stow Symlinks       |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

step "Linking dotfiles"

# Backup existing configs
backup_dirs=(.config/hypr .config/waybar .config/rofi .config/kitty .config/fish)
for dir in "${backup_dirs[@]}"; do
    [[ -d "$HOME/$dir" && ! -L "$HOME/$dir" ]] && {
        mv "$HOME/$dir" "$HOME/$dir.bak"
        info "Backed up $dir"
    }
done

# Stow dotfiles
cd "$DOTFILES"
if stow -v . 2>&1 | grep -q "LINK"; then
    ok "Dotfiles linked"
else
    stow . 2>/dev/null && ok "Dotfiles linked" || warn "Some conflicts - check manually"
fi
