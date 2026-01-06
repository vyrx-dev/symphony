#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Theme Importer      |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"
THEMES_DIR="$DOTFILES/themes"

source "$SCRIPT_DIR/init.sh"
source "$SCRIPT_DIR/terminals.sh"
source "$SCRIPT_DIR/hyprland.sh"
source "$SCRIPT_DIR/waybar.sh"
source "$SCRIPT_DIR/rofi.sh"
source "$SCRIPT_DIR/gtk.sh"
source "$SCRIPT_DIR/btop.sh"
source "$SCRIPT_DIR/cava.sh"
source "$SCRIPT_DIR/wal.sh"
source "$SCRIPT_DIR/yazi.sh"
source "$SCRIPT_DIR/rmpc.sh"
source "$SCRIPT_DIR/starship.sh"
source "$SCRIPT_DIR/vesktop.sh"
source "$SCRIPT_DIR/obsidian.sh"
source "$SCRIPT_DIR/spicetify.sh"

write_configs() {
    local theme_name="$1" theme_dest="$2" theme_bg="$3" theme_fg="$4"; shift 4
    local c=("$@")
    
    # export as globals for gen_* functions
    name="$theme_name"
    dest="$theme_dest"
    bg="$theme_bg"
    fg="$theme_fg"
    
    [[ -z "$bg" ]] && bg="#0f0f0f"
    [[ -z "$fg" ]] && fg="#e0e0e0"
    
    black=${c[0]:-$bg} red=${c[1]:-#cc6666} green=${c[2]:-#b5bd68}
    yellow=${c[3]:-#f0c674} blue=${c[4]:-#81a2be} magenta=${c[5]:-#b294bb}
    cyan=${c[6]:-#8abeb7} white=${c[7]:-#c5c8c6} bblack=${c[8]:-#969896}
    bred=${c[9]:-$red} bgreen=${c[10]:-$green} byellow=${c[11]:-$yellow}
    bblue=${c[12]:-$blue} bmagenta=${c[13]:-$magenta} bcyan=${c[14]:-$cyan}
    bwhite=${c[15]:-#ffffff}
    accent=$blue
    surface=$(lighten "$bg" 20)
    
    gen_terminals
    gen_hyprland
    gen_waybar
    gen_rofi
    gen_gtk
    gen_btop
    gen_cava
    gen_wal
    gen_yazi
    gen_rmpc
    gen_starship
    gen_vesktop
    gen_obsidian
    gen_spicetify
}

run_import() {
    local url="$1"
    [[ -z "$url" ]] && { err "usage: symphony import <url|user/repo>"; exit 1; }
    
    [[ "$url" =~ ^https?:// ]] || url="https://github.com/$url"
    url="${url%.git}"
    
    local name
    name=$(basename "$url" | sed 's/^omarchy-//; s/^omakub-//; s/-theme$//; s/-omarchy$//' | tr '[:upper:]' '[:lower:]')
    name="$name (omarchy)"
    local dest="$THEMES_DIR/$name"
    
    if [[ -d "$dest" ]]; then
        printf 'theme "%s" exists. overwrite? [y/N] ' "$name"
        read -r ans
        [[ "$ans" == "y" ]] || exit 0
        rm -rf "$dest"
    fi
    
    local tmp="/tmp/symphony-import.$$"
    trap 'rm -rf "$tmp"' EXIT
    
    info "cloning $url..."
    git clone --depth 1 --quiet "$url" "$tmp/repo" || { err "clone failed"; exit 1; }
    
    info "extracting colors..."
    local colors
    colors=$(get_colors "$tmp/repo") || { err "no kitty.conf or alacritty.toml found"; exit 1; }
    read -ra C <<< "$colors"
    local bg="${C[0]}" fg="${C[1]}"
    local palette=("${C[@]:2}")
    
    info "creating $name..."
    mkdir -p "$dest"/{backgrounds,.cache/wal}
    mkdir -p "$dest/.config"/{alacritty,btop/themes,cava,ghostty,gtk-3.0,gtk-4.0,hypr/theme,kitty,nvim,obsidian,rmpc/themes,rofi,spicetify/Themes/symphony,vesktop/themes,waybar,yazi}
    
    # copy wallpapers
    [[ -d "$tmp/repo/backgrounds" ]] && cp "$tmp/repo/backgrounds"/* "$dest/backgrounds/" 2>/dev/null || true
    for f in "$tmp/repo"/background*.{jpg,png,webp}; do
        [[ -f "$f" ]] && cp "$f" "$dest/backgrounds/"
    done 2>/dev/null
    
    local wall
    wall=$(find "$dest/backgrounds" -type f 2>/dev/null | head -1)
    [[ -n "$wall" ]] && ln -sfn "backgrounds/${wall##*/}" "$dest/wallpaper"
    
    write_configs "$name" "$dest" "$bg" "$fg" "${palette[@]}"
    
    # use original theme configs if available
    [[ -f "$tmp/repo/btop.theme" ]] && cp "$tmp/repo/btop.theme" "$dest/.config/btop/themes/current.theme"
    [[ -f "$tmp/repo/neovim.lua" ]] && cp "$tmp/repo/neovim.lua" "$dest/.config/nvim/theme.lua"
    
    ok "imported $name"
    local parent_script="$(dirname "$SCRIPT_DIR")/symphony"
    if [[ "$(cat "$HOME/.config/symphony/.current-theme" 2>/dev/null)" == "$name" ]]; then
        "$parent_script" reload
    else
        "$parent_script" switch "$name"
    fi
}

run_import "$@"
