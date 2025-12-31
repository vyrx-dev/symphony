#!/usr/bin/env bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Uninstaller         |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES/install/utils.sh"

# Core stuff - don't offer to uninstall
skip=(
    base-devel git stow fish tmux neovim nautilus
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
    networkmanager bluez bluez-utils polkit-gnome power-profiles-daemon
    xdg-utils xdg-user-dirs libnotify wl-clipboard ffmpeg jq wget curl unzip
    qt5-wayland qt6-wayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects
    ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd noto-fonts-emoji
    pamixer playerctl inotify-tools wtype v4l-utils adw-gtk-theme
)

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Functions                                                             │
# ╰───────────────────────────────────────────────────────────────────────╯

is_skipped() {
    local pkg="$1"
    for s in "${skip[@]}"; do [[ "$s" == "$pkg" ]] && return 0; done
    return 1
}

get_packages() {
    # Grab package names from packages.sh
    sed -n '/^packages=(/,/^)/p' "$DOTFILES/install/packages.sh" | grep -oP '^\s+\K[a-z][a-z0-9_-]*'
    sed -n '/^applications=(/,/^)/p' "$DOTFILES/install/packages.sh" | grep -oP '^\s+\K[a-z][a-z0-9_-]*'
}

do_unstow() {
    step "Removing symlinks"
    cd "$DOTFILES"
    stow -D . 2>/dev/null && ok "Removed" || warn "Some failed"
}

restore_backups() {
    step "Restoring backups"

    # Find most recent backup directory (dotfiles-backup, dotfiles-backup-2, etc.)
    local latest=$(ls -d "$HOME"/dotfiles-backup* 2>/dev/null | sort -V | tail -1)
    [[ -z "$latest" || ! -d "$latest" ]] && { info "No backups found"; return 0; }

    info "Restoring from: $latest"

    # Restore preserving directory structure
    while IFS= read -r file; do
        local dest="$HOME/${file#$latest/}"
        mkdir -p "$(dirname "$dest")"
        cp "$file" "$dest"
    done < <(find "$latest" -type f)

    ok "Backups restored"
    return 0
}

ask_packages() {
    command -v gum &>/dev/null || return 0
    gum confirm "Uninstall packages?" || return 0

    step "Checking installed"
    local list=()
    for pkg in $(get_packages | sort -u); do
        is_skipped "$pkg" && continue
        pkg_installed "$pkg" && list+=("$pkg")
    done

    [[ ${#list[@]} -eq 0 ]] && { info "Nothing to remove"; return 0; }

    local selected
    selected=$(printf '%s\n' "${list[@]}" | gum choose --no-limit --height 20) || return 0
    [[ -z "$selected" ]] && return 0

    warn "Removing: $selected"
    gum confirm "Sure?" || return 0

    if aur_installed; then
        $(get_aur_helper) -Rns --noconfirm $selected 2>/dev/null || true
    else
        sudo pacman -Rns --noconfirm $selected 2>/dev/null || true
    fi
    ok "Done"
    return 0
}

clean_shell() {
    step "Cleaning shell config"
    for rc in ~/.bashrc ~/.zshrc ~/.config/fish/config.fish; do
        [[ -f "$rc" && ! -L "$rc" ]] || continue
        grep -q "[Ss]ymphony" "$rc" 2>/dev/null || continue
        sed -i '/[Ss]ymphony/d;/install\/themes/d' "$rc"
        ok "$(basename "$rc")"
    done
    return 0
}

clean_desktop_entries() {
    step "Cleaning desktop entries"
    local target_dir="$HOME/.local/share/applications"
    local apps_dir="$DOTFILES/.local/share/applications"
    
    [[ -d "$target_dir" ]] || return 0
    
    # Collect entries installed by Symphony
    local entries=()
    
    # Web apps from dotfiles
    for file in "$apps_dir"/*.desktop; do
        [[ -f "$file" ]] || continue
        local name=$(basename "$file")
        [[ -f "$target_dir/$name" ]] && entries+=("$name")
    done
    
    # Hidden app overrides (created by hide-apps script, contain NoDisplay=true)
    while IFS= read -r -d '' file; do
        local name=$(basename "$file")
        grep -q "NoDisplay=true" "$file" 2>/dev/null && entries+=("$name")
    done < <(find "$target_dir" -maxdepth 1 -name "*.desktop" -print0 2>/dev/null)
    
    # Dedupe
    mapfile -t entries < <(printf '%s\n' "${entries[@]}" | sort -u)
    
    [[ ${#entries[@]} -eq 0 ]] && { info "No desktop entries to clean"; return 0; }
    
    if command -v gum &>/dev/null; then
        gum confirm "Remove ${#entries[@]} desktop entries?" || return 0
        
        local selected
        selected=$(printf '%s\n' "${entries[@]}" | gum choose --no-limit --height 20) || return 0
        [[ -z "$selected" ]] && return 0
        
        for entry in $selected; do
            rm -f "$target_dir/$entry"
            ok "Removed $entry"
        done
    else
        read -rp "Remove ${#entries[@]} desktop entries? [y/N] " c
        [[ "$c" =~ ^[Yy]$ ]] || return 0
        
        for entry in "${entries[@]}"; do
            rm -f "$target_dir/$entry"
        done
        ok "Removed ${#entries[@]} entries"
    fi
    
    # Refresh
    command -v update-desktop-database &>/dev/null && update-desktop-database "$target_dir" 2>/dev/null
    return 0
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Main                                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

# Handle --desktop-entries flag for quick fix
if [[ "$1" == "--desktop-entries" ]]; then
    target_dir="$HOME/.local/share/applications"
    if [[ -L "$target_dir" ]]; then
        rm "$target_dir"
        ok "Removed symlink: $target_dir"
        info "Now re-run ./install.sh"
    else
        info "Not a symlink, running full cleanup..."
        clean_desktop_entries
    fi
    exit 0
fi

clear
show_banner
echo
warn "Symphony Uninstaller"
echo
echo "  - Remove symlinks"
echo "  - Restore backed up configs"  
echo "  - Optionally remove packages"
echo "  - Clean shell PATH"
echo

if command -v gum &>/dev/null; then
    gum confirm "Continue?" || exit 0
else
    read -rp "Continue? [y/N] " c && [[ "$c" =~ ^[Yy]$ ]] || exit 0
fi

echo
do_unstow
restore_backups
clean_desktop_entries
ask_packages
clean_shell

echo
ok "Done"
info "Restart session to complete"
echo
