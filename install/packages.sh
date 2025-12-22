#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Package Installer   |-/ /--|#
#|/ /---+---------------------+/ /---|#

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Core Packages                                                         │
# ╰───────────────────────────────────────────────────────────────────────╯

packages=(
	# Build
	base-devel git stow

	# Hyprland
	hyprland hypridle hyprlock hyprpicker hyprsunset
	xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
	qt5-wayland qt6-wayland uwsm

	# Desktop
	waybar rofi swaync swayosd swww wlogout

	# Terminal & Shell
	kitty alacritty fish starship tmux

	# CLI Tools
	eza bat fd ripgrep fzf zoxide jq

	# Files
	yazi nautilus

	# Editor
	neovim lazygit

	# Screenshot & Recording
	grim slurp satty wl-clipboard gpu-screen-recorder ffmpeg v4l-utils

	# Clipboard
	cliphist wl-clip-persist

	# Audio
	pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
	pamixer pavucontrol wiremix

	# Music
	mpd mpc rmpc cava playerctl

	# Network & Bluetooth
	networkmanager network-manager-applet impala
	bluez bluez-utils blueberry

	# System
	polkit-gnome brightnessctl ddcutil power-profiles-daemon
	libnotify xdg-utils xdg-user-dirs inotify-tools

	# Theming
	matugen-bin nwg-look adw-gtk-theme bibata-cursor-theme-bin

	# Rofi Extras
	rofimoji wtype

	# Monitoring
	btop fastfetch

	# Fonts
	ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd noto-fonts-emoji

	# Display Manager
	sddm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects

	# Utilities
	python-terminaltexteffects gum wget curl unzip localsend-bin
)

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Optional Applications                                                 │
# ╰───────────────────────────────────────────────────────────────────────╯

applications=(
	brave-bin zen-browser-bin firefox chromium
	obsidian bitwarden code visual-studio-code-bin
	vesktop-bin discord spotify-launcher spicetify-cli
	mpv yt-dlp steam lutris gamemode mangohud
)

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Functions                                                             │
# ╰───────────────────────────────────────────────────────────────────────╯

setup_aur() {
	aur_installed && return 0
	info "Installing yay..."
	local tmp=$(mktemp -d)
	git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin" --depth 1 &>/dev/null
	(cd "$tmp/yay-bin" && makepkg -si --noconfirm) &>/dev/null
	rm -rf "$tmp"
	ok "yay"
}

do_install() {
	local aur=$(get_aur_helper)
	local official=() from_aur=()

	for pkg in "$@"; do
		[[ -z "$pkg" ]] && continue
		if pkg_installed "$pkg"; then
			ok "$pkg"
		elif pacman -Si "$pkg" &>/dev/null; then
			official+=("$pkg")
		elif [[ -n "$aur" ]] && $aur -Si "$pkg" &>/dev/null 2>&1; then
			from_aur+=("$pkg")
		else
			warn "$pkg not found"
		fi
	done

	if [[ ${#official[@]} -gt 0 ]]; then
		echo
		info "Installing ${#official[@]} packages from official repos..."
		echo
		sudo pacman -S --needed --noconfirm "${official[@]}"
	fi

	if [[ ${#from_aur[@]} -gt 0 ]]; then
		echo
		info "Installing ${#from_aur[@]} packages from AUR..."
		echo
		$aur -S --needed --noconfirm "${from_aur[@]}"
	fi

	return 0
}

ask_applications() {
	command -v gum &>/dev/null || return 0
	echo
	gum confirm "Install optional applications?" || return 0

	local selected
	selected=$(printf '%s\n' "${applications[@]}" | gum choose --no-limit --height 20) || return 0
	[[ -z "$selected" ]] && return 0

	step "Installing applications"
	do_install $selected
	return 0
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Run                                                                   │
# ╰───────────────────────────────────────────────────────────────────────╯

step "Installing packages"
setup_aur
do_install "${packages[@]}"
ask_applications
true
