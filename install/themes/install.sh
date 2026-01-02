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

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Error Handling                                                        │
# ╰───────────────────────────────────────────────────────────────────────╯

QR_DISCORD='
█████████████████████████████████████
████ ▄▄▄▄▄ █▀█ █▄█▄ ▀█▄▄ █ ▄▄▄▄▄ ████
████ █   █ █▀▀▀█ ██▀█▀█▄▀█ █   █ ████
████ █▄▄▄█ █▀ █▀▀██▄█▀▀▄ █ █▄▄▄█ ████
████▄▄▄▄▄▄▄█▄▀ ▀▄█▄▀▄█ █ █▄▄▄▄▄▄▄████
████  ▄ ▄█▄ ▄▄▀▄▀▀█▀ ▄█▀  ▀ ▀▄█▄▀████
████  ▀██ ▄███▄█▀ ▄ █▄▄▀ █ ▄▀▀█▀█████
████ ▄██ █▄▀█ ▄█▄█▄▄ ▄  ██▀▀▀▄▄█▀████
█████▄██ █▄▀▀▄█ ▄█▀▄▄█ █  ▀▄▀▄▄▀█████
████▀█▄▄▀▄▄▄█▀▀▄▀▀▀██▀  ▀▀▀ ▀▄ █▀████
████ █▀▀ ▄▄ █▀▄█▀ ▄█ ██▀ ▀█▄▄█▄▀█████
████▄█▄▄█▄▄█▀█ █▄█▄▀█▄▀▄ ▄▄▄ ▀   ████
████ ▄▄▄▄▄ █▄▀█ ▄█▀▄▀▄   █▄█ ▄▄██████
████ █   █ █ █▀▄▀▀▀ ▄▀ ▀  ▄▄▄▀ ▄▄████
████ █▄▄▄█ █ ███▀ ▄▀ ▀▄█▀▄ ▄  ▄ █████
████▄▄▄▄▄▄▄█▄▄▄█▄█▄███▄▄█▄▄▄▄█▄██████
█████████████████████████████████████'

catch_error() {
    clear
    show_cursor
    echo
    echo -e "${C_CORAL}  Oops! Something didn't go as planned.${C_RESET}"
    echo
    echo -e "${C_DIM}  Don't worry - this happens sometimes.${C_RESET}"
    echo
    echo -e "${C_PINK}$QR_DISCORD${C_RESET}"
    echo
    echo -e "${C_WHITE}  Scan to DM me on Discord, happy to help!${C_RESET}"
    echo -e "${C_DIM}  https://discord.com/users/1087059817367080980${C_RESET}"
    echo
    echo -e "${C_DIM}  Or create an issue: https://github.com/vyrx-dev/dotfiles/issues${C_RESET}"
    echo
    exit 1
}

trap catch_error ERR INT

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Fullscreen Re-launch                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" && "$SYMPHONY_FULLSCREEN" != "1" ]]; then
    export SYMPHONY_FULLSCREEN=1
    if command -v alacritty &>/dev/null; then
        alacritty --class Screensaver \
            -o font.size=12 \
            -e "$SCRIPT_DIR/install.sh" "$@" && exit 0
    fi
fi

# Colors - Symphony gradient
C_GOLD="\033[38;2;255;235;59m"
C_CORAL="\033[38;2;255;138;128m"
C_PINK="\033[38;2;244;143;177m"
C_WHITE="\033[38;5;255m"
C_DIM="\033[38;5;250m"
C_DIMMER="\033[38;5;245m"
C_RED="\033[38;2;255;82;82m"
C_RESET="\033[0m"

C_ACCENT="$C_PINK"
C_OK="$C_GOLD"
C_NOTE="$C_CORAL"

# Terminal dimensions
TERM_WIDTH=80
TERM_HEIGHT=24
CONTENT_WIDTH=55
PADDING_LEFT=0

init_dimensions() {
    [[ "$SYMPHONY_FULLSCREEN" == "1" ]] && sleep 0.15
    TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
    TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
    PADDING_LEFT=$(( (TERM_WIDTH - CONTENT_WIDTH) / 2 ))
    [[ $PADDING_LEFT -lt 0 ]] && PADDING_LEFT=0 || true
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Helpers                                                               │
# ╰───────────────────────────────────────────────────────────────────────╯

hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }

print_logo() {
    [[ -f "$LOGO_FILE" ]] && echo -e "${C_ACCENT}" && cat "$LOGO_FILE" && echo -e "${C_RESET}"
}

print_musical() {
    [[ -f "$MUSICAL_FILE" ]] && echo -e "${C_ACCENT}" && cat "$MUSICAL_FILE" && echo -e "${C_RESET}"
}

center_text() {
    local text="$1" color="${2:-$C_RESET}"
    local pad=$(( (TERM_WIDTH - ${#text}) / 2 ))
    [[ $pad -lt 0 ]] && pad=0
    printf "%${pad}s" ""
    echo -e "${color}${text}${C_RESET}"
}

heading() {
    echo
    echo
    if [[ $HAS_GUM -eq 1 ]]; then
        gum style --foreground 218 --bold --padding "0 0 0 $PADDING_LEFT" "$1"
    else
        printf "%${PADDING_LEFT}s" "" && echo -e "${C_ACCENT}$1${C_RESET}"
    fi
    echo
}

spin() {
    local msg="$1" dur="${2:-0.8}"
    if [[ $HAS_GUM -eq 1 ]]; then
        gum spin --spinner dot --spinner.foreground="218" --title.foreground="255" \
            --padding "0 0 0 $PADDING_LEFT" --title "$msg" -- sleep "$dur"
    else
        printf "%${PADDING_LEFT}s" "" && echo -e "${C_WHITE}○ $msg${C_RESET}" && sleep "$dur"
    fi
}

status_line() {
    local icon="$1" text="$2" color="$3"
    printf "%${PADDING_LEFT}s" "" && echo -e "${color}${icon}${C_RESET} ${text}"
}

check_mark() { status_line "✓" "$1" "$C_OK"; }
cross_mark() { status_line "✗" "$1" "$C_RED"; }
skip_mark()  { status_line "○" "$1" "$C_DIMMER"; }
found_item() { status_line "♪" "$1" "$C_CORAL"; }

info_line() {
    printf "%${PADDING_LEFT}s" "" && echo -e "${C_DIM}$1${C_RESET}"
}

padded_line() {
    printf "%${PADDING_LEFT}s" "" && echo -e "$1"
}

count_themes() {
    local n=0
    for d in "$THEMES_DIR"/*/; do
        [[ -d "$d" ]] || continue
        local name=$(basename "$d")
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
    echo

    # Animated logo
    if [[ -f "$LOGO_FILE" && $HAS_TTE -eq 1 ]]; then
        tte -i "$LOGO_FILE" \
            --canvas-width 0 \
            --anchor-text c \
            --frame-rate 120 beams \
            --beam-row-symbols ▂ ▁ _ \
            --beam-column-symbols ▌ ▍ ▎ ▏ \
            --beam-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 EC407A \
            --beam-gradient-steps 2 6 \
            --final-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-steps 12 \
            --final-gradient-direction horizontal 2>/dev/null || print_logo
    else
        print_logo
    fi

    # Phase 1: Tuning the Instruments
    heading "Tuning the Instruments"
    
    local missing=()
    for dep in stow hyprctl swww; do
        if command -v "$dep" &>/dev/null; then
            check_mark "$dep"
        else
            cross_mark "$dep"
            missing+=("$dep")
        fi
        sleep 0.08
    done
    
    for dep in waybar rofi gum tte matugen; do
        command -v "$dep" &>/dev/null && check_mark "$dep" || skip_mark "$dep"
        sleep 0.08
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo
        padded_line "${C_RED}Missing required:${C_RESET}"
        for dep in "${missing[@]}"; do
            padded_line "${C_DIM}  sudo pacman -S $dep${C_RESET}"
        done
        show_cursor
        exit 1
    fi

    # Phase 2: Gathering the Orchestra
    heading "Gathering the Orchestra"
    
    local apps=("kitty" "ghostty" "alacritty" "waybar" "rofi" "swaync" "btop" "cava" "yazi" "rmpc" "nvim" "obsidian" "vesktop")
    for app in "${apps[@]}"; do
        if command -v "$app" &>/dev/null; then
            found_item "$app"
        else
            skip_mark "$app"
        fi
        sleep 0.08
    done

    # Phase 3: Setting the Stage
    heading "Setting the Stage"
    
    spin "Arranging the seats" 0.4
    mkdir -p "$SYMPHONY_DIR" "$HOME/.config/rmpc/themes" "$HOME/.cache/wal"
    spin "Adjusting the lights" 0.35
    chmod +x "$SCRIPT_DIR/symphony" "$SCRIPT_DIR/hooks"/*.sh 2>/dev/null || true
    spin "Testing the acoustics" 0.35
    check_mark "Stage is set"

    # PATH setup
    heading "Tuning the Paths"
    
    local rc="" shell_name=""
    [[ -f "$HOME/.config/fish/config.fish" ]] && rc="$HOME/.config/fish/config.fish" && shell_name="fish"
    [[ -z "$rc" && -f "$HOME/.zshrc" ]] && rc="$HOME/.zshrc" && shell_name="zsh"
    [[ -z "$rc" && -f "$HOME/.bashrc" ]] && rc="$HOME/.bashrc" && shell_name="bash"

    spin "Checking shell config" 0.35
    if [[ -n "$rc" ]] && ! grep -q "symphony" "$rc" 2>/dev/null; then
        echo -e "\n# Symphony" >> "$rc"
        [[ "$shell_name" == "fish" ]] && echo "set -gx PATH $SCRIPT_DIR \$PATH" >> "$rc" ||
            echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$rc"
        check_mark "Added to $shell_name PATH"
    else
        check_mark "PATH already configured"
    fi

    # Phase 4: Composing the Themes
    heading "Composing the Themes"
    
    local theme_count=$(count_themes)
    spin "Reading the scores" 0.3
    check_mark "$theme_count compositions found"
    echo
    spin "Mixing harmonies" 0.3
    spin "Balancing tones" 0.3
    spin "Polishing melodies" 0.3
    spin "Final rehearsal" 0.25
    check_mark "All pieces perfected"

    # Transition
    echo
    echo
    echo
    
    local curtains="The curtains rise..."
    if [[ $HAS_TTE -eq 1 ]]; then
        echo "$curtains" | tte \
            --canvas-width "$TERM_WIDTH" \
            --anchor-text c \
            --frame-rate 60 highlight \
            --final-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-steps 8 \
            --final-gradient-direction horizontal 2>/dev/null || center_text "$curtains" "$C_ACCENT"
    else
        center_text "$curtains" "$C_ACCENT"
    fi
    
    echo
    sleep 1.2
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Page 2: Finale                                                        │
# ╰───────────────────────────────────────────────────────────────────────╯

page_two() {
    clear
    echo
    echo
    echo

    # Animated musical banner
    if [[ -f "$MUSICAL_FILE" && $HAS_TTE -eq 1 ]]; then
        tte -i "$MUSICAL_FILE" \
            --canvas-width "$TERM_WIDTH" \
            --anchor-text c \
            --frame-rate 120 spotlights \
            --spotlight-count 3 \
            --search-duration 250 \
            --beam-width-ratio 2.5 \
            --final-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-steps 12 \
            --final-gradient-direction horizontal 2>/dev/null || print_musical
    else
        print_musical
    fi

    echo
    echo

    center_text "Your symphony. You decide how to play." "$C_WHITE"
    center_text "For those who notice the little things." "$C_DIM"

    echo
    echo
    echo

    center_text "After reboot, pick your first theme:" "$C_DIM"
    echo
    center_text "symphony switch <theme>  ·  Super+Ctrl+Shift+Space" "$C_CORAL"
    echo
    center_text "This fixes any initial Hyprland errors." "$C_DIMMER"

    echo
    echo
    echo

    center_text "symphony help" "$C_PINK"
    center_text "for available commands" "$C_DIMMER"

    echo
    echo

    center_text "https://github.com/vyrx-dev/dotfiles/issues" "$C_DIMMER"

    echo
    echo
    
    # Animated footer
    local footer="♪ Let the music play ♫"
    if [[ $HAS_TTE -eq 1 ]]; then
        echo "$footer" | tte \
            --canvas-width "$TERM_WIDTH" \
            --anchor-text c \
            --frame-rate 60 waves \
            --wave-symbols "♩" "♪" "♫" "♬" "♫" \
            --wave-gradient-stops FFEB3B FFB74D FF8A80 F48FB1 \
            --wave-gradient-steps 6 \
            --wave-length 6 \
            --wave-count 1 \
            --final-gradient-stops FFB74D FF8A80 F48FB1 EC407A \
            --final-gradient-direction horizontal 2>/dev/null || center_text "$footer" "$C_ACCENT"
    else
        center_text "$footer" "$C_ACCENT"
    fi

    echo
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Main                                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

main() {
    hide_cursor
    trap 'show_cursor' EXIT
    
    init_dimensions
    
    # Skip confirmation if called from main installer
    if [[ "${SYMPHONY_INSTALLING:-}" != "1" ]]; then
        clear
        
        local vertical_pad=$(( (TERM_HEIGHT - 6) / 2 ))
        for ((i=0; i<vertical_pad; i++)); do echo; done
        
        center_text "This will switch configs and reload apps." "$C_NOTE"
        echo
        
        if [[ $HAS_GUM -eq 1 ]]; then
            center_text "Continue?" "$C_WHITE"
            echo
            local btn_pad=$(( (TERM_WIDTH - 27) / 2 ))
            hide_cursor
            gum confirm --padding "0 0 0 $btn_pad" --show-help=false --affirmative " Yes " --negative " No  " "" || exit 0
            hide_cursor
        else
            center_text "Continue? [y/N]" "$C_WHITE"
            read -rp "" c && [[ "$c" =~ ^[Yy]$ ]] || exit 0
        fi
    fi

    page_one
    page_two
    
    # Reboot prompt
    local btn_pad=$(( (TERM_WIDTH - 29) / 2 ))
    
    if [[ $HAS_GUM -eq 1 ]]; then
        hide_cursor
        if gum confirm --padding "0 0 0 $btn_pad" --show-help=false --default=yes --affirmative " Reboot " --negative " Later  " ""; then
            hide_cursor
            center_text "Rebooting..." "$C_OK"
            sleep 1
            systemctl reboot
        else
            hide_cursor
            echo
            echo
            center_text "A reboot is needed to complete the setup." "$C_DIM"
            center_text "Restart when you're ready." "$C_DIM"
        fi
    else
        echo
        center_text "Reboot now? [Y/n]" "$C_WHITE"
        read -rp "" c
        if [[ ! "$c" =~ ^[Nn]$ ]]; then
            center_text "Rebooting..." "$C_OK"
            sleep 1
            systemctl reboot
        else
            echo
            center_text "A reboot is needed to complete the setup." "$C_DIM"
            center_text "Restart when you're ready." "$C_DIM"
        fi
    fi
    echo
}

main
