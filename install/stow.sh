#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Stow Symlinks       |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

step "Linking dotfiles"
cd "$DOTFILES"

# Prevent stow from folding top-level directories
mkdir -p "$HOME/.config" "$HOME/.local/share"

# Backup conflicting files/dirs before stow runs
backup_conflicts() {
    local dry_run
    dry_run=$(stow -n -v . 2>&1)

    local -A seen
    while IFS= read -r line; do
        [[ "$line" == *"existing target"* ]] || continue
        local path=$(echo "$line" | sed -n 's/.*existing target \([^ ]*\) since.*/\1/p')
        [[ -z "$path" ]] && continue
        [[ -n "${seen[$path]}" ]] && continue
        seen[$path]=1

        local target="$HOME/$path"
        [[ -e "$target" && ! -L "$target" ]] || continue

        mkdir -p "$BACKUP_DIR/$(dirname "$path")"
        mv "$target" "$BACKUP_DIR/$path"
        info "Backed up: $path"
    done <<< "$dry_run"

    [[ -d "$BACKUP_DIR" ]] && info "Backups: $BACKUP_DIR"
}

backup_conflicts

if stow . 2>/dev/null; then
    ok "Dotfiles linked"
else
    err "Stow failed"
    stow -v . 2>&1 | head -10
    exit 1
fi
