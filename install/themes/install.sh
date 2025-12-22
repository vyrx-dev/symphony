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
LOGO_FILE="$BRANDING/symphony.txt"
MUSICAL_FILE="$BRANDING/musical.txt"

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

HAS_TTE=$(command -v tte &>/dev/null && echo 1 || echo 0)

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Helpers                                                               │
# ╰───────────────────────────────────────────────────────────────────────╯

print_logo() {
    [[ -f "$LOGO_FILE" ]] && echo -e "${C_ACCENT}" && cat "$LOGO_FILE" && echo -e "${C_RESET}"
}

print_musical() {
    [[ -f "$MUSICAL_FILE" ]] && echo -e "${C_ACCENT}" && cat "$MUSICAL_FILE" && echo -e "${C_RESET}"
}

heading() {
    if [[ $HAS_GUM -eq 1 ]]; then
        gum style --foreground 218 --bold --margin "1 0 0 0" "  ♫ $1"
    else
        echo && echo -e "${C_ACCENT}  ♫ $1${C_RESET}"
    fi
}

spin() {
    local msg="$1" dur="${2:-0.8}"
    if [[ $HAS_GUM -eq 1 ]]; then
        gum spin --spinner dot --spinner.foreground="218" --title.foreground="245" --title "  $msg" -- sleep "$dur"
    else
        echo -e "${C_DIM}  ○ $msg${C_RESET}" && sleep "$dur"
    fi
}

check_mark() { echo -e "${C_OK}  ✓${C_RESET} $1"; sleep 0.08; }
cross_mark() { echo -e "${C_RED}  ✗${C_RESET} $1"; sleep 0.08; }
skip_mark()  { echo -e "${C_DIMMER}  ○${C_RESET} ${C_DIMMER}$1${C_RESET}"; sleep 0.08; }
found_item() { echo -e "${C_NOTE}  ♪${C_RESET} $1"; sleep 0.08; }
info_line()  { echo -e "${C_DIM}  $1${C_RESET}"; }
divider()    { echo -e "${C_DIMMER}  ───────────────────────────────────────────────────────${C_RESET}"; }

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

    # Animated logo with TTE beams
    if [[ -f "$LOGO_FILE" ]] && [[ $HAS_TTE -eq 1 ]]; then
        cat "$LOGO_FILE" | tte \
            --frame-rate 60 beams \
            --beam-row-symbols "▂" "▁" "_" \
            --beam-column-symbols "▌" "▍" "▎" "▏" \
            --beam-delay 3 \
            --beam-row-speed-range 30-120 \
            --beam-column-speed-range 18-30 \
            --beam-gradient-stops FFEB3B FFB74D FF8A80 \
            --beam-gradient-steps 2 6 \
            --beam-gradient-frames 2 \
            --final-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-steps 12 \
            --final-gradient-frames 2 \
            --final-gradient-direction vertical \
            --final-wipe-speed 3 2>/dev/null || print_logo
    else
        print_logo
    fi

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
        command -v "$dep" &>/dev/null && check_mark "$dep" || skip_mark "$dep (optional)"
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo
        echo -e "${C_RED}  Missing required dependencies:${C_RESET}"
        for dep in "${missing[@]}"; do
            echo -e "${C_DIM}    sudo pacman -S $dep${C_RESET}"
        done
        exit 1
    fi

    # Applications
    heading "Discovering Applications"
    local apps=("waybar" "rofi" "swaync" "btop" "cava" "yazi" "rmpc" "obsidian" "vesktop")
    local found_apps=()
    for app in "${apps[@]}"; do
        if command -v "$app" &>/dev/null; then
            found_item "$app"
            found_apps+=("$app")
        fi
    done
    [[ -n "$terminal" ]] && found_item "$terminal" && found_apps+=("$terminal")
    echo
    info_line "Found ${#found_apps[@]} supported applications"

    # Directories
    heading "Setting Up Directories"
    spin "Creating config structure" 0.6
    mkdir -p "$SYMPHONY_DIR" "$HOME/.config/rmpc/themes" "$HOME/.cache/wal"
    spin "Setting permissions" 0.4
    chmod +x "$SCRIPT_DIR/symphony" "$SCRIPT_DIR/hooks"/*.sh 2>/dev/null || true
    info_line "Directories and scripts ready"

    # PATH
    heading "Setting Up PATH"
    local rc="" shell_name=""
    [[ -f "$HOME/.config/fish/config.fish" ]] && rc="$HOME/.config/fish/config.fish" && shell_name="fish"
    [[ -z "$rc" && -f "$HOME/.zshrc" ]] && rc="$HOME/.zshrc" && shell_name="zsh"
    [[ -z "$rc" && -f "$HOME/.bashrc" ]] && rc="$HOME/.bashrc" && shell_name="bash"

    if [[ -n "$rc" ]] && ! grep -q "symphony" "$rc" 2>/dev/null; then
        echo -e "\n# Symphony" >> "$rc"
        [[ "$shell_name" == "fish" ]] && echo "set -gx PATH $SCRIPT_DIR \$PATH" >> "$rc" ||
            echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$rc"
        check_mark "Added to $shell_name PATH"
    else
        check_mark "PATH already configured"
    fi

    # Themes
    heading "Discovering Themes"
    local theme_count=$(count_themes)
    spin "Scanning theme collection" 0.5
    info_line "Found $theme_count themes"

    # Visual flair
    heading "Generating Configurations"
    spin "Tuning colors" 0.35
    spin "Harmonizing palettes" 0.35
    spin "Composing gradients" 0.35
    spin "Orchestrating styles" 0.35
    spin "Finalizing arrangements" 0.25
    info_line "All themes configured"

    sleep 0.5
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Page 2: Apply Theme & Finale                                          │
# ╰───────────────────────────────────────────────────────────────────────╯

page_two() {
    clear
    echo

    # Animated musical banner with TTE waves
    if [[ -f "$MUSICAL_FILE" ]] && [[ $HAS_TTE -eq 1 ]]; then
        cat "$MUSICAL_FILE" | tte \
            --frame-rate 60 waves \
            --wave-symbols "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" "▇" "▆" "▅" "▄" "▃" "▂" "▁" \
            --wave-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 \
            --wave-gradient-steps 6 \
            --wave-count 3 \
            --wave-length 2 \
            --wave-direction row_bottom_to_top \
            --final-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-steps 12 \
            --final-gradient-direction horizontal 2>/dev/null || print_musical
    else
        print_musical
    fi

    # Apply default theme
    heading "Applying Theme"
    local theme="sakura"
    mkdir -p "$SYMPHONY_DIR"
    echo "$theme" > "$SYMPHONY_DIR/.current-theme"

    if [[ -x "$SCRIPT_DIR/symphony" ]]; then
        spin "Switching to $theme" 1.0
        "$SCRIPT_DIR/symphony" switch "$theme" &>/dev/null || true
        check_mark "Theme applied"
        check_mark "Wallpaper set"
        check_mark "Applications reloaded"
    else
        cross_mark "symphony not found"
    fi

    divider

    # Commands
    if [[ $HAS_GUM -eq 1 ]]; then
        gum style --foreground 218 --bold "  Commands"
    else
        echo -e "${C_ACCENT}  Commands${C_RESET}"
    fi
    echo -e "  ${C_WHITE}symphony list${C_RESET}            ${C_DIM}show all themes${C_RESET}"
    echo -e "  ${C_WHITE}symphony switch${C_RESET}          ${C_DIM}pick a theme interactively${C_RESET}"
    echo -e "  ${C_WHITE}symphony switch zen${C_RESET}      ${C_DIM}switch to a specific theme${C_RESET}"
    echo -e "  ${C_WHITE}symphony current${C_RESET}         ${C_DIM}show active theme${C_RESET}"
    echo -e "  ${C_WHITE}symphony reload${C_RESET}          ${C_DIM}re-apply current theme${C_RESET}"
    echo

    # Keybindings
    if [[ $HAS_GUM -eq 1 ]]; then
        gum style --foreground 218 --bold "  Keybindings"
    else
        echo -e "${C_ACCENT}  Keybindings${C_RESET}"
    fi
    echo -e "  ${C_NOTE}Super + Ctrl + Shift + Space${C_RESET}   ${C_DIM}theme switcher${C_RESET}"
    echo -e "  ${C_NOTE}Super + Ctrl + Space${C_RESET}           ${C_DIM}matugen theme from wallpaper${C_RESET}"
    echo -e "  ${C_NOTE}Super + Alt + Space${C_RESET}            ${C_DIM}wallpaper picker${C_RESET}"
    echo -e "  ${C_NOTE}Super + Alt + Left/Right${C_RESET}       ${C_DIM}cycle wallpapers${C_RESET}"
    echo -e "  ${C_NOTE}Super + Backspace${C_RESET}              ${C_DIM}toggle terminal transparency${C_RESET}"
    echo -e "  ${C_NOTE}Super + Ctrl + Backspace${C_RESET}       ${C_DIM}toggle focus/vibe mode${C_RESET}"

    divider

    # Themes with colors
    if [[ $HAS_GUM -eq 1 ]]; then
        gum style --foreground 218 --bold "  Themes"
    else
        echo -e "${C_ACCENT}  Themes${C_RESET}"
    fi
    echo -e "  \033[38;2;178;207;168mdynamic\033[0m            ${C_DIM}colors from wallpaper${C_RESET}"
    echo -e "  \033[38;2;200;168;152mespresso\033[0m           ${C_DIM}warm coffee tones${C_RESET}"
    echo -e "  \033[38;2;112;207;108mforest\033[0m             ${C_DIM}calm greens, earthy${C_RESET}"
    echo -e "  \033[38;2;216;166;87mgruvbox-material\033[0m   ${C_DIM}retro warm tones${C_RESET}"
    echo -e "  \033[38;2;126;156;216mkanagawa\033[0m           ${C_DIM}japanese ink painting${C_RESET}"
    echo -e "  \033[38;2;129;161;193mnordic\033[0m             ${C_DIM}arctic frost blues${C_RESET}"
    echo -e "  \033[38;2;235;111;146mrose-pine\033[0m          ${C_DIM}soft & romantic${C_RESET}"
    echo -e "  \033[38;2;232;95;111msakura\033[0m             ${C_DIM}cherry blossom pink${C_RESET}"
    echo -e "  \033[38;2;122;162;247mtokyo-night\033[0m        ${C_DIM}neon city lights${C_RESET}"
    echo -e "  \033[38;2;194;184;255mvoid\033[0m               ${C_DIM}deep purple cosmos${C_RESET}"
    echo -e "  \033[38;2;152;152;154mzen\033[0m                ${C_DIM}minimal monochrome${C_RESET}"

    divider
    echo
    echo -e "  ${C_DIM}Found a problem? https://github.com/vyrx-dev/dotfiles/issues/new${C_RESET}"
    echo

    # Animated footer
    local footer="♪ Let the music play ♫"
    if [[ $HAS_TTE -eq 1 ]]; then
        echo "  $footer" | tte \
            --frame-rate 60 waves \
            --wave-symbols "♩" "♪" "♫" "♬" "♫" \
            --wave-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 \
            --wave-gradient-steps 6 \
            --wave-length 6 \
            --wave-count 1 \
            --final-gradient-stops FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-direction horizontal 2>/dev/null || echo -e "${C_ACCENT}  $footer${C_RESET}"
    else
        echo -e "${C_ACCENT}  $footer${C_RESET}"
    fi
    echo
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Main                                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

main() {
    # Skip confirmation if called from main installer
    if [[ "${SYMPHONY_INSTALLING:-}" != "1" ]]; then
        echo
        echo -e "${C_NOTE}  ⚠ This will switch configs and reload apps.${C_RESET}"
        echo
        if [[ $HAS_GUM -eq 1 ]]; then
            gum confirm "Continue?" || exit 0
        else
            read -rp "  Continue? [y/N] " c && [[ "$c" =~ ^[Yy]$ ]] || exit 0
        fi
    fi

    page_one
    page_two
}

main
