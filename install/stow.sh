#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Stow Symlinks       |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Backup dir: dotfiles-backup, dotfiles-backup-2, etc.
BACKUP_DIR="$HOME/dotfiles-backup"
i=2; while [[ -d "$BACKUP_DIR" ]]; do BACKUP_DIR="$HOME/dotfiles-backup-$i"; ((i++)); done

step "Linking dotfiles"
cd "$DOTFILES"

# Prevent stow from symlinking ~/.config itself
mkdir -p "$HOME/.config" "$HOME/.local/share"

# Backup existing configs so stow creates clean directory symlinks
backup_if_exists() {
    for item in "$1"/*; do
        [[ -e "$item" ]] || continue
        local name=$(basename "$item")
        local target="$2/$name"
        [[ -e "$target" && ! -L "$target" ]] || continue
        mkdir -p "$BACKUP_DIR/$1"
        mv "$target" "$BACKUP_DIR/$1/$name"
        info "Backed up: $1/$name"
    done
}

backup_if_exists ".config" "$HOME/.config"
backup_if_exists ".local/share" "$HOME/.local/share"

if stow . 2>/dev/null; then
    ok "Dotfiles linked"
else
    err "Stow failed:"
    stow -v . 2>&1 | head -5
    exit 1
fi

[[ -d "$BACKUP_DIR" ]] && info "Your old configs: $BACKUP_DIR"
