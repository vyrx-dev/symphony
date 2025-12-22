#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Theme Installer     |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$(dirname "$SCRIPT_DIR")")"
THEMES_DIR="$DOTFILES/themes"
SYMPHONY_DIR="$HOME/.config/symphony"
BRANDING="$DOTFILES/branding"

source "$DOTFILES/install/utils.sh"

# Colors
C_ACCENT="\033[38;5;218m"
C_OK="\033[38;5;215m"
C_NOTE="\033[38;5;210m"
C_WHITE="\033[38;5;255m"
C_DIM="\033[38;5;245m"
C_DIMMER="\033[38;5;240m"
C_RED="\033[38;5;203m"
C_RESET="\033[0m"

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Helpers                                                               │
# ╰───────────────────────────────────────────────────────────────────────╯

heading() {
    [[ $HAS_GUM -eq 1 ]] && gum style --foreground 218 --bold --margin "1 0 0 0" "  ♫ $1" ||
        echo -e "\n${C_ACCENT}  ♫ $1${C_RESET}"
}

check_mark() { echo -e "${C_OK}  ✓${C_RESET} $1"; sleep 0.08; }
cross_mark() { echo -e "${C_RED}  ✗${C_RESET} $1"; sleep 0.08; }
skip_mark()  { echo -e "${C_DIMMER}  ○${C_RESET} ${C_DIMMER}$1${C_RESET}"; sleep 0.08; }
found_item() { echo -e "${C_NOTE}  ♪${C_RESET} $1"; sleep 0.08; }
info_line()  { echo -e "${C_DIM}  $1${C_RESET}"; }
divider()    { echo -e "${C_DIMMER}  ───────────────────────────────────────────────────────${C_RESET}"; }

spinner() {
    local msg="$1"; shift
    [[ $HAS_GUM -eq 1 ]] && gum spin --spinner dot --title "  $msg" -- "$@" 2>/dev/null ||
        { info_line "$msg"; "$@" &>/dev/null || true; }
}

count_themes() {
    local n=0
    for d in "$THEMES_DIR"/*/; do
        [[ -d "$d" ]] || continue
        name=$(basename "$d")
        [[ "$name" != "Wallpapers" && "$name" != ".git" ]] && ((n++)) || true
    done
    echo "$n"
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Page 1: Setup                                                         │
# ╰───────────────────────────────────────────────────────────────────────╯

page_one() {
    clear
    echo
    show_logo "$BRANDING/symphony.txt"

    # Dependencies
    heading "Checking Dependencies"
    local missing=()
    for dep in stow hyprctl swww; do
        command -v "$dep" &>/dev/null && check_mark "$dep" || { cross_mark "$dep"; missing+=("$dep"); }
    done

    local terminal=""
    for t in kitty ghostty alacritty; do
        command -v "$t" &>/dev/null && { check_mark "$t"; terminal="$t"; break; }
    done
    [[ -z "$terminal" ]] && { cross_mark "terminal"; missing+=("kitty"); }

    for dep in waybar rofi gum tte matugen; do
        command -v "$dep" &>/dev/null && check_mark "$dep" || skip_mark "$dep"
    done

    [[ ${#missing[@]} -gt 0 ]] && {
        echo -e "\n${C_RED}  Missing: ${missing[*]}${C_RESET}"
        exit 1
    }

    # Applications
    heading "Discovering Applications"
    local found=0
    for app in waybar rofi swaync btop cava yazi rmpc obsidian vesktop $terminal; do
        command -v "$app" &>/dev/null && { found_item "$app"; ((found++)) || true; }
    done
    info_line "Found $found supported apps"

    # Directories
    heading "Setting Up"
    spinner "Creating directories" mkdir -p "$SYMPHONY_DIR" "$HOME/.config/rmpc/themes" "$HOME/.cache/wal"
    spinner "Setting permissions" chmod +x "$SCRIPT_DIR/symphony" "$SCRIPT_DIR/hooks"/*.sh 2>/dev/null

    # PATH
    local rc="" shell=""
    [[ -f "$HOME/.config/fish/config.fish" ]] && rc="$HOME/.config/fish/config.fish" shell="fish"
    [[ -z "$rc" && -f "$HOME/.zshrc" ]] && rc="$HOME/.zshrc" shell="zsh"
    [[ -z "$rc" && -f "$HOME/.bashrc" ]] && rc="$HOME/.bashrc" shell="bash"

    if [[ -n "$rc" ]] && ! grep -q "symphony" "$rc" 2>/dev/null; then
        echo -e "\n# Symphony" >> "$rc"
        [[ "$shell" == "fish" ]] && echo "set -gx PATH $SCRIPT_DIR \$PATH" >> "$rc" ||
            echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$rc"
        check_mark "Added to $shell PATH"
    else
        check_mark "PATH configured"
    fi

    # Themes
    heading "Loading Themes"
    spinner "Scanning collection" sleep 0.3
    info_line "Found $(count_themes) themes"

    # Visual flair
    heading "Preparing"
    spinner "Tuning colors" sleep 0.3
    spinner "Harmonizing palettes" sleep 0.3
    spinner "Composing styles" sleep 0.3
    info_line "Ready"

    sleep 0.3
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Page 2: Apply Theme & Finale                                          │
# ╰───────────────────────────────────────────────────────────────────────╯

page_two() {
    clear
    echo
    show_musical "$BRANDING/musical.txt"

    # Apply default theme
    heading "Applying Theme"
    local theme="sakura"
    mkdir -p "$SYMPHONY_DIR"
    echo "$theme" > "$SYMPHONY_DIR/.current-theme"

    if [[ -x "$SCRIPT_DIR/symphony" ]]; then
        spinner "Switching to $theme" "$SCRIPT_DIR/symphony" switch "$theme"
        check_mark "Theme applied"
        check_mark "Wallpaper set"
        check_mark "Apps reloaded"
    else
        cross_mark "symphony not found"
    fi

    divider

    # Commands
    echo -e "${C_ACCENT}  Commands${C_RESET}"
    echo -e "  ${C_WHITE}symphony list${C_RESET}            ${C_DIM}show all themes${C_RESET}"
    echo -e "  ${C_WHITE}symphony switch${C_RESET}          ${C_DIM}pick interactively${C_RESET}"
    echo -e "  ${C_WHITE}symphony switch zen${C_RESET}      ${C_DIM}switch directly${C_RESET}"
    echo -e "  ${C_WHITE}symphony reload${C_RESET}          ${C_DIM}re-apply current${C_RESET}"
    echo

    # Keybindings
    echo -e "${C_ACCENT}  Keybindings${C_RESET}"
    echo -e "  ${C_NOTE}Super+Ctrl+Shift+Space${C_RESET}   ${C_DIM}theme switcher${C_RESET}"
    echo -e "  ${C_NOTE}Super+Ctrl+Space${C_RESET}         ${C_DIM}wallpaper theme${C_RESET}"
    echo -e "  ${C_NOTE}Super+Alt+Space${C_RESET}          ${C_DIM}wallpaper picker${C_RESET}"
    echo -e "  ${C_NOTE}Super+Alt+Left/Right${C_RESET}     ${C_DIM}cycle wallpapers${C_RESET}"

    divider

    # Themes
    echo -e "${C_ACCENT}  Themes${C_RESET}"
    echo -e "  \033[38;2;178;207;168mdynamic\033[0m            ${C_DIM}from wallpaper${C_RESET}"
    echo -e "  \033[38;2;200;168;152mespresso\033[0m           ${C_DIM}warm coffee${C_RESET}"
    echo -e "  \033[38;2;112;207;108mforest\033[0m             ${C_DIM}calm greens${C_RESET}"
    echo -e "  \033[38;2;216;166;87mgruvbox-material\033[0m   ${C_DIM}retro warm${C_RESET}"
    echo -e "  \033[38;2;126;156;216mkanagawa\033[0m           ${C_DIM}ink painting${C_RESET}"
    echo -e "  \033[38;2;129;161;193mnordic\033[0m             ${C_DIM}arctic frost${C_RESET}"
    echo -e "  \033[38;2;235;111;146mrose-pine\033[0m          ${C_DIM}soft romantic${C_RESET}"
    echo -e "  \033[38;2;232;95;111msakura\033[0m             ${C_DIM}cherry blossom${C_RESET}"
    echo -e "  \033[38;2;122;162;247mtokyo-night\033[0m        ${C_DIM}neon city${C_RESET}"
    echo -e "  \033[38;2;194;184;255mvoid\033[0m               ${C_DIM}deep purple${C_RESET}"
    echo -e "  \033[38;2;152;152;154mzen\033[0m                ${C_DIM}monochrome${C_RESET}"

    divider
    echo
    echo -e "${C_ACCENT}  ♪ Let the music play ♫${C_RESET}"
    echo
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Main                                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

main() {
    # Skip confirmation if called from main installer
    if [[ "${SYMPHONY_INSTALLING:-}" != "1" ]]; then
        echo
        warn "This will switch configs and reload apps."
        confirm "Continue?" || exit 0
    fi

    page_one
    page_two
}

main
