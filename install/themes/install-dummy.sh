#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| DUMMY Installer     |-/ /--|#
#|/ /---+---------------------+/ /---|#
#
# Visual replica of install.sh - does NOT change anything
# Use this to test visuals before editing main installer
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$(dirname "$SCRIPT_DIR")")"
THEMES_DIR="$DOTFILES/themes"
BRANDING="$DOTFILES/branding"
LOGO_FILE="$BRANDING/symphony.txt"
MUSICAL_FILE="$BRANDING/musical.txt"

source "$DOTFILES/install/utils.sh"

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Fullscreen Re-launch                                                  │
# ╰───────────────────────────────────────────────────────────────────────╯

if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" && "$SYMPHONY_FULLSCREEN" != "1" ]]; then
    export SYMPHONY_FULLSCREEN=1
    if command -v alacritty &>/dev/null; then
        alacritty --class Screensaver \
            -o font.size=12 \
            -o 'colors.cursor.cursor="#000000"' \
            -o cursor.blink_interval=0 \
            -e "$SCRIPT_DIR/install-dummy.sh" "$@" && exit 0
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


# Terminal dimensions - will be set in main() after fullscreen is ready
TERM_WIDTH=80
TERM_HEIGHT=24
CONTENT_WIDTH=55
PADDING_LEFT=0

init_dimensions() {
    # Brief wait for fullscreen terminal to be ready
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

    # Animated logo with TTE beams
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
    
    for dep in stow hyprctl swww; do
        command -v "$dep" &>/dev/null && check_mark "$dep" || cross_mark "$dep"
        sleep 0.08
    done
    
    for dep in waybar rofi gum tte matugen; do
        command -v "$dep" &>/dev/null && check_mark "$dep" || skip_mark "$dep"
        sleep 0.08
    done

    # Phase 2: Gathering the Orchestra
    heading "Gathering the Orchestra"
    
    local apps=("kitty" "ghostty" "alacritty" "waybar" "rofi" "swaync" "btop" "cava" "yazi" "rmpc" "nvim" "obsidian" "vesktop")
    local found_apps=()
    for app in "${apps[@]}"; do
        if command -v "$app" &>/dev/null; then
            found_item "$app"
            found_apps+=("$app")
        else
            skip_mark "$app"
        fi
        sleep 0.08
    done
    
    echo
    info_line "${#found_apps[@]} musicians ready"

    # Phase 3: Setting the Stage
    heading "Setting the Stage"
    
    spin "Arranging the seats" 0.4
    spin "Adjusting the lights" 0.35
    spin "Testing the acoustics" 0.35
    check_mark "Stage is set"

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

    # Transition to page 2
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

    # Animated musical banner with TTE spotlights
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
    echo
    center_text "For those who notice the little things." "$C_DIM"

    echo
    echo

    center_text "Found a problem? https://github.com/vyrx-dev/dotfiles/issues" "$C_DIMMER"

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
    
    # Initialize dimensions after fullscreen terminal is ready
    init_dimensions
    
    clear
    
    # Center initial prompt vertically
    local vertical_pad=$(( (TERM_HEIGHT - 6) / 2 ))
    for ((i=0; i<vertical_pad; i++)); do echo; done
    
    center_text "⚠ DUMMY MODE - This will NOT change anything" "$C_NOTE"
    echo
    
    if [[ $HAS_GUM -eq 1 ]]; then
        center_text "Run visual test?" "$C_WHITE"
        echo
        local btn_pad=$(( (TERM_WIDTH - 27) / 2 ))
        hide_cursor
        gum confirm --padding "0 0 0 $btn_pad" --show-help=false --affirmative " Yes " --negative " No  " "" || exit 0
        hide_cursor
    else
        echo
        center_text "Run visual test? [y/N]" "$C_WHITE"
        read -rp "" c && [[ "$c" =~ ^[Yy]$ ]] || exit 0
    fi

    page_one
    page_two
    
    # Reboot prompt
    local btn_pad=$(( (TERM_WIDTH - 29) / 2 ))
    
    if [[ $HAS_GUM -eq 1 ]]; then
        hide_cursor
        if gum confirm --padding "0 0 0 $btn_pad" --show-help=false --default=yes --affirmative " Reboot " --negative " Later  " ""; then
            hide_cursor
            center_text "✓ DUMMY - would reboot here" "$C_OK"
        else
            hide_cursor
            echo
            center_text "A reboot is needed to complete the setup." "$C_DIM"
            center_text "Restart when you're ready." "$C_DIM"
        fi
    else
        echo
        center_text "Reboot now? [Y/n]" "$C_WHITE"
        read -rp "" c
        if [[ ! "$c" =~ ^[Nn]$ ]]; then
            center_text "✓ DUMMY - would reboot here" "$C_OK"
        else
            echo
            center_text "A reboot is needed to complete the setup." "$C_DIM"
            center_text "Restart when you're ready." "$C_DIM"
        fi
    fi
    echo
}

main
