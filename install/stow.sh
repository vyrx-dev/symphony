#!/bin/bash
# Symlink dotfiles using stow

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Dirs that commonly conflict on fresh installs
conflicts=(.config/hypr .config/waybar .config/rofi .config/kitty .config/fish)

step "Linking dotfiles"

# Backup existing configs
for dir in "${conflicts[@]}"; do
    target="$HOME/$dir"
    [[ -e "$target" && ! -L "$target" ]] || continue
    [[ -e "$target.bak" ]] && rm -rf "$target.bak"
    mv "$target" "$target.bak"
    info "Backed up $dir"
done

cd "$DOTFILES"

if stow . 2>&1 | grep -q "conflict"; then
    warn "Conflicts detected"
    stow . 2>&1 | grep "existing target" | head -5
    err "Resolve conflicts manually"
    return 1 2>/dev/null || exit 1
fi

stow . || { err "Stow failed"; return 1 2>/dev/null || exit 1; }
ok "Dotfiles linked"
