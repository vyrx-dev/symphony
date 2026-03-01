#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Deploy (cp-based)   |-/ /--|#
#|/ /---+---------------------+/ /---|#

SYMPHONY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M)"
BACKUP_DIR="$HOME/.config/symphony/backups/$TIMESTAMP"

# Dirs inside symphony that should NOT be deployed to home
IGNORE_DIRS=(
    "themes"
    "install"
    "bin"
    "config"
    "local"
    "assets"
    "branding"
    ".git"
    ".github"
    "default"
)

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Helpers                                                               │
# ╰───────────────────────────────────────────────────────────────────────╯

should_ignore() {
    local name="$1"
    for ignored in "${IGNORE_DIRS[@]}"; do
        [[ "$name" == "$ignored" ]] && return 0
    done
    return 1
}

files_differ() {
    local src="$1" dst="$2"
    [[ ! -e "$dst" ]] && return 1
    [[ -L "$dst" ]] && return 0
    diff -rq "$src" "$dst" &>/dev/null && return 1 || return 0
}

backup_file() {
    local src="$1"
    local rel="${src#$HOME/}"
    # Only backup real files/dirs that differ from what we're deploying
    if [[ -e "$src" && ! -L "$src" ]]; then
        mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
        cp -a "$src" "$BACKUP_DIR/$rel"
    fi
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Deploy .config and .local/share                                       │
# ╰───────────────────────────────────────────────────────────────────────╯

deploy_dir() {
    local src_base="$1"  # e.g. $SYMPHONY_DIR/config
    local dst_base="$2"  # e.g. $HOME/.config

    [[ -d "$src_base" ]] || return 0

    for item in "$src_base"/*/; do
        [[ -d "$item" ]] || continue
        local name="$(basename "$item")"
        local dst="$dst_base/$name"

        # Backup existing only if it differs from source
        if [[ -d "$dst" && ! -L "$dst" ]] && files_differ "$item" "$dst"; then
            backup_file "$dst"
        fi

        # Remove existing symlink
        [[ -L "$dst" ]] && rm "$dst"

        # Copy recursively
        cp -rf "$item" "$dst_base/"
    done
}

deploy_files() {
    local src_base="$1"
    local dst_base="$2"

    for item in "$src_base"/*; do
        [[ -f "$item" ]] || continue
        local name="$(basename "$item")"
        local dst="$dst_base/$name"

        # Backup existing file only if it differs
        if [[ -f "$dst" && ! -L "$dst" ]] && ! diff -q "$item" "$dst" &>/dev/null; then
            backup_file "$dst"
        fi
        cp -f "$item" "$dst"
    done
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Deploy scripts to ~/.local/bin                                        │
# ╰───────────────────────────────────────────────────────────────────────╯

deploy_scripts() {
    local bin_dir="$HOME/.local/bin"
    mkdir -p "$bin_dir"

    for script in "$SYMPHONY_DIR"/bin/*; do
        [[ -f "$script" ]] || continue
        cp -f "$script" "$bin_dir/"
        chmod +x "$bin_dir/$(basename "$script")"
    done
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Main                                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

step "Deploying configs"

# Ensure directories exist
mkdir -p "$HOME/.config" "$HOME/.local/share" "$HOME/.local/bin"
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Wallpapers"

# Remove stale symlinks before deploying
for f in "$HOME"/.config/*; do
    [[ -L "$f" ]] || continue
    local_target="$(readlink "$f" 2>/dev/null)"
    [[ "$local_target" == *symphony* ]] && rm "$f"
done

# Deploy config
deploy_dir "$SYMPHONY_DIR/config" "$HOME/.config"
deploy_files "$SYMPHONY_DIR/config" "$HOME/.config"  # standalone files like brave-flags.conf

# Deploy local/share
deploy_dir "$SYMPHONY_DIR/local/share" "$HOME/.local/share"

# Deploy scripts
deploy_scripts

# Deploy themes to ~/.config/symphony/themes/
SYMPHONY_CONFIG="$HOME/.config/symphony"
mkdir -p "$SYMPHONY_CONFIG/themes"
for theme_dir in "$SYMPHONY_DIR"/themes/*/; do
    [[ -d "$theme_dir" ]] || continue
    theme_name=$(basename "$theme_dir")
    # Only copy if not already there (preserves user modifications)
    [[ -d "$SYMPHONY_CONFIG/themes/$theme_name" ]] || cp -r "$theme_dir" "$SYMPHONY_CONFIG/themes/"
done

# Link default theme if none active
if [[ ! -L "$SYMPHONY_CONFIG/current" ]]; then
    if [[ -d "$SYMPHONY_CONFIG/themes/sakura" ]]; then
        ln -sfn "$SYMPHONY_CONFIG/themes/sakura" "$SYMPHONY_CONFIG/current"
        echo "sakura" > "$SYMPHONY_CONFIG/.current-theme"
    elif [[ -d "$SYMPHONY_CONFIG/themes/nordic" ]]; then
        ln -sfn "$SYMPHONY_CONFIG/themes/nordic" "$SYMPHONY_CONFIG/current"
        echo "nordic" > "$SYMPHONY_CONFIG/.current-theme"
    fi
fi

ok "Dotfiles deployed"

# Report backup location
if [[ -d "$BACKUP_DIR" && "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
    info "Backed up existing configs: $BACKUP_DIR"
    warn "To restore: symphony restore"
fi
