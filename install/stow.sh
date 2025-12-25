#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Stow Symlinks       |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup"

step "Linking dotfiles"

cd "$DOTFILES"

# Dry run to detect conflicts
dry_run=$(stow -n -v . 2>&1)
conflicts=$(echo "$dry_run" | grep "cannot stow" | sed -n 's/.*existing target \([^ ]*\).*/\1/p')

if [[ -n "$conflicts" ]]; then
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Backup each conflicting file/directory
    while IFS= read -r item; do
        [[ -z "$item" ]] && continue
        target="$HOME/$item"
        if [[ -e "$target" && ! -L "$target" ]]; then
            mkdir -p "$BACKUP_DIR/$(dirname "$item")"
            mv "$target" "$BACKUP_DIR/$item"
            info "Backed up: $item"
        fi
    done <<< "$conflicts"
    
    info "Backups saved to: $BACKUP_DIR"
fi

# Now stow for real
output=$(stow -v . 2>&1)

if echo "$output" | grep -qE "cannot stow|All operations aborted|ERROR"; then
    err "Failed to link dotfiles"
    echo "$output" | grep -v "^LINK:" | sed 's/^/  /'
    info "Fix conflicts and retry: cd ~/dotfiles && stow ."
    exit 1
fi

ok "Dotfiles linked"
