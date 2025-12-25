#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Stow Symlinks       |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

step "Linking dotfiles"

# Backup directory to store conflicting files
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Function to backup a file or directory
backup_item() {
    local item="$1"
    local full_path="$HOME/$item"
    
    if [[ ! -e "$full_path" ]]; then
        return 0
    fi
    
    # Create backup directory structure
    mkdir -p "$BACKUP_DIR/$(dirname "$item")"
    
    # Move the item to backup
    mv "$full_path" "$BACKUP_DIR/$item"
    info "Backed up: $item"
}

# Perform dry-run to detect conflicts
cd "$DOTFILES"
info "Checking for conflicts..."
dry_run_output=$(stow -n -v . 2>&1)
dry_run_status=$?

# Parse conflicts from dry-run
conflicts=()
absolute_symlinks=()

while IFS= read -r line; do
    # Match "cannot stow" errors
    if [[ "$line" =~ "cannot stow" ]]; then
        # Extract the target path from the error message
        if [[ "$line" =~ "existing target "([^[:space:]]+) ]]; then
            target="${BASH_REMATCH[1]}"
            conflicts+=("$target")
        fi
    fi
    # Match absolute symlink warnings
    if [[ "$line" =~ "source is an absolute symlink" ]]; then
        if [[ "$line" =~ dotfiles/([^[:space:]]+) ]]; then
            symlink_path="${BASH_REMATCH[1]}"
            absolute_symlinks+=("$symlink_path")
        fi
    fi
done <<< "$dry_run_output"

# Remove absolute symlinks first
for symlink in "${absolute_symlinks[@]}"; do
    target="$HOME/$symlink"
    if [[ -L "$target" ]]; then
        backup_item "$symlink"
        warn "Removed absolute symlink: $symlink"
    fi
done

# Backup all conflicting files and directories
for conflict in "${conflicts[@]}"; do
    backup_item "$conflict"
done

# Show backup location if any backups were made
if [[ -d "$BACKUP_DIR" ]]; then
    info "Backups saved to: $BACKUP_DIR"
fi

# Now run stow for real
info "Creating symlinks..."
stow_output=$(stow -v . 2>&1)
stow_status=$?

# Check if stow succeeded
# Note: We ignore "WARNING: in simulation mode" as that's expected for dry-runs
# We check for actual error indicators: non-zero exit, "cannot stow", "All operations aborted", "ERROR"
if [[ $stow_status -ne 0 ]] || echo "$stow_output" | grep -qE "cannot stow|All operations aborted|ERROR"; then
    err "Failed to link dotfiles"
    echo
    echo "$stow_output" | grep -vE "^LINK:|^MKDIR:" | sed 's/^/  /'
    echo
    if [[ -d "$BACKUP_DIR" ]]; then
        info "Backups are in: $BACKUP_DIR"
    fi
    info "To retry: cd ~/dotfiles && stow ."
    exit 1
fi

ok "Dotfiles linked"
