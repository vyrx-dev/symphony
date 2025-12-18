#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  Symphony Installer
#  https://github.com/vyrx-dev/dotfiles
# ═══════════════════════════════════════════════════════════════════

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"
BRANDING="$DOTFILES/branding"
THEMES_DIR="$DOTFILES/themes"
SYMPHONY_DIR="$HOME/.config/symphony"
LOGO_FILE="$BRANDING/symphony.txt"
MUSICAL_FILE="$BRANDING/musical.txt"

# Warm pink palette
C_ACCENT="\033[38;5;218m"
C_OK="\033[38;5;215m"
C_NOTE="\033[38;5;210m"
C_WHITE="\033[38;5;255m"
C_DIM="\033[38;5;245m"
C_DIMMER="\033[38;5;240m"
C_RED="\033[38;5;203m"
C_RESET="\033[0m"

HAS_GUM=$(command -v gum &>/dev/null && echo 1 || echo 0)
HAS_TTE=$(command -v tte &>/dev/null && echo 1 || echo 0)

# ═══════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════

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
	local msg="$1"
	shift
	if [[ $HAS_GUM -eq 1 ]]; then
		gum spin --spinner dot --spinner.foreground="218" --title.foreground="245" --title "  $msg" -- "$@" 2>/dev/null
	else
		echo -e "${C_DIM}  ○ $msg${C_RESET}"
		"$@" >/dev/null 2>&1
	fi
}

check_mark() {
	echo -e "${C_OK}  ✓${C_RESET} $1"
	sleep 0.08
}
cross_mark() {
	echo -e "${C_RED}  ✗${C_RESET} $1"
	sleep 0.08
}
skip_mark() {
	echo -e "${C_DIMMER}  ○${C_RESET} ${C_DIMMER}$1${C_RESET}"
	sleep 0.08
}
found_item() {
	echo -e "${C_NOTE}  ♪${C_RESET} $1"
	sleep 0.08
}

info_line() {
	[[ $HAS_GUM -eq 1 ]] && gum style --foreground 245 "  $1" || echo -e "${C_DIM}  $1${C_RESET}"
}

divider() { echo -e "${C_DIMMER}  ───────────────────────────────────────────────────────${C_RESET}"; }

count_themes() {
	local count=0
	for d in "$THEMES_DIR"/*/; do
		[[ -d "$d" ]] || continue
		local name=$(basename "$d")
		[[ "$name" != "Wallpapers" && "$name" != ".git" ]] && ((count++)) || true
	done
	echo "$count"
}

get_themes() {
	for d in "$THEMES_DIR"/*/; do
		[[ -d "$d" ]] || continue
		local name=$(basename "$d")
		[[ "$name" != "Wallpapers" && "$name" != ".git" ]] && echo "$name"
	done
}

# ═══════════════════════════════════════════════════════════════════
# Page 1: Setup & Discovery
# ═══════════════════════════════════════════════════════════════════

page_one() {
	clear
	echo

	# Beams animation
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

	# Check required dependencies
	heading "Checking Dependencies"

	local missing_required=()
	local required=("stow" "hyprctl" "swww")

	for dep in "${required[@]}"; do
		if command -v "$dep" &>/dev/null; then
			check_mark "$dep"
		else
			cross_mark "$dep (required)"
			missing_required+=("$dep")
		fi
	done

	# Check terminal - only need one
	local has_terminal=0
	local terminal_name=""
	for term in kitty ghostty alacritty; do
		if command -v "$term" &>/dev/null; then
			check_mark "$term"
			has_terminal=1
			terminal_name="$term"
			break
		fi
	done
	[[ $has_terminal -eq 0 ]] && cross_mark "terminal (install kitty, ghostty, or alacritty)"

	# Check optional dependencies
	local optional=("waybar" "rofi" "gum" "tte" "matugen")
	for dep in "${optional[@]}"; do
		if command -v "$dep" &>/dev/null; then
			check_mark "$dep"
		else
			skip_mark "$dep (optional)"
		fi
	done

	# Exit if missing required deps
	if [[ ${#missing_required[@]} -gt 0 ]] || [[ $has_terminal -eq 0 ]]; then
		echo
		echo -e "${C_RED}  Missing required dependencies:${C_RESET}"
		for dep in "${missing_required[@]}"; do
			echo -e "${C_DIM}    sudo pacman -S $dep${C_RESET}"
		done
		[[ $has_terminal -eq 0 ]] && echo -e "${C_DIM}    sudo pacman -S kitty  # or ghostty/alacritty${C_RESET}"
		echo
		exit 1
	fi

	# Discovering Applications
	heading "Discovering Applications"

	local apps=("waybar" "rofi" "swaync" "btop" "cava" "yazi" "rmpc" "obsidian" "vesktop")
	local found_apps=()

	for app in "${apps[@]}"; do
		if command -v "$app" &>/dev/null; then
			found_item "$app"
			found_apps+=("$app")
		fi
	done
	[[ -n "$terminal_name" ]] && found_item "$terminal_name" && found_apps+=("$terminal_name")

	echo
	info_line "Found ${#found_apps[@]} supported applications"

	# Setting Up Directories
	heading "Setting Up Directories"

	spin "Creating config structure" bash -c "mkdir -p '$SYMPHONY_DIR' '$HOME/.config/rmpc/themes' '$HOME/.cache/wal'"
	spin "Setting permissions" bash -c "chmod +x '$SCRIPT_DIR'/symphony '$SCRIPT_DIR'/hooks/*.sh 2>/dev/null || true"
	info_line "Directories and scripts ready"

	# Setup PATH
	heading "Setting Up PATH"

	local rc="" shell_name=""
	[[ -f "$HOME/.config/fish/config.fish" ]] && rc="$HOME/.config/fish/config.fish" && shell_name="fish"
	[[ -z "$rc" && -f "$HOME/.zshrc" ]] && rc="$HOME/.zshrc" && shell_name="zsh"
	[[ -z "$rc" && -f "$HOME/.bashrc" ]] && rc="$HOME/.bashrc" && shell_name="bash"

	if [[ -n "$rc" ]] && ! grep -q "symphony" "$rc" 2>/dev/null; then
		echo -e "\n# Symphony" >>"$rc"
		[[ "$shell_name" == "fish" ]] && echo "set -gx PATH $SCRIPT_DIR \$PATH" >>"$rc" ||
			echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >>"$rc"
		check_mark "Added to $shell_name PATH"
	else
		check_mark "PATH already configured"
	fi

	# Discovering Themes
	heading "Discovering Themes"

	local theme_count=$(count_themes)
	spin "Scanning theme collection" sleep 0.3
	info_line "Found $theme_count themes"

	sleep 0.3
}

# ═══════════════════════════════════════════════════════════════════
# Page 2: Theme Selection + Finale
# ═══════════════════════════════════════════════════════════════════

page_two() {
	clear
	echo

	# Waves animation
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

	# Select Theme
	heading "Choose Your Theme"

	local themes=()
	mapfile -t themes < <(get_themes)

	# Bail if no themes found
	if [[ ${#themes[@]} -eq 0 ]]; then
		cross_mark "No themes found in $THEMES_DIR"
		exit 1
	fi

	local selected_theme=""
	if [[ $HAS_GUM -eq 1 ]]; then
		selected_theme=$(printf '%s\n' "${themes[@]}" | gum choose --height=12) || true
	else
		echo
		local i=1
		for t in "${themes[@]}"; do
			echo -e "  ${C_DIM}$i)${C_RESET} $t"
			((i++))
		done
		echo
		read -rp "  Enter number or name: " choice
		if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le "${#themes[@]}" ]]; then
			selected_theme="${themes[$((choice - 1))]}"
		else
			# Validate theme name exists
			for t in "${themes[@]}"; do
				[[ "$t" == "$choice" ]] && selected_theme="$choice" && break
			done
		fi
	fi

	# Default to first theme if nothing selected
	[[ -z "$selected_theme" ]] && selected_theme="${themes[0]}"

	# Ensure symphony dir exists before writing
	mkdir -p "$SYMPHONY_DIR"
	echo "$selected_theme" >"$SYMPHONY_DIR/.current-theme"

	# Apply Theme
	heading "Applying Theme"

	if [[ -x "$SCRIPT_DIR/symphony" ]]; then
		spin "Switching to $selected_theme" bash -c "'$SCRIPT_DIR/symphony' switch '$selected_theme' >/dev/null 2>&1" || true
		check_mark "Theme applied"
		check_mark "Wallpaper set"
		check_mark "Applications reloaded"
	else
		cross_mark "symphony script not found"
		info_line "Run: chmod +x $SCRIPT_DIR/symphony"
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

	# Themes list with colors
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

	# Footer
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

# ═══════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════

main() {
	page_one
	page_two
}

main
