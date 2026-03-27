#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Package Installer   |-/ /--|#
#|/ /---+---------------------+/ /---|#

SYMPHONY_DIR="${SYMPHONY_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
[[ -z "$RESET" ]] && source "$SYMPHONY_DIR/install/utils.sh"

packages=(
	base-devel git git-lfs
	hyprland hypridle hyprlock hyprpicker hyprsunset
	xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
	qt5-wayland qt6-wayland uwsm
	waybar rofi swaync swayosd awww brave-bin
	kitty alacritty fish starship tmux
	eza bat fd ripgrep fzf zoxide jq
	yazi nautilus 
	neovim lazygit
	grim slurp satty wl-clipboard gpu-screen-recorder ffmpeg v4l-utils
	cliphist wl-clip-persist
	pipewire pipewire-alsa pipewire-pulse wireplumber
	pamixer wiremix
	mpd mpc rmpc cava playerctl mpdscribble
	spotify-launcher spicetify-cli mpd-mpris
	networkmanager nmgui-bin kdeconnect
	bluez bluez-utils blueman
	polkit-gnome brightnessctl ddcutil power-profiles-daemon upower
	libnotify xdg-utils xdg-user-dirs inotify-tools
	gnome-keyring libsecret xorg-xhost libappindicator
	matugen nwg-look adw-gtk-theme bibata-cursor-theme-bin imagemagick
	rofimoji wtype
	btop fastfetch chafa
	ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd noto-fonts-emoji
	sddm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects
	python-terminaltexteffects gum wget curl unzip localsend deno npm keyd tree-sitter-cli
)

applications=(
	zen-browser-bin firefox chromium
	obsidian bitwarden code visual-studio-code-bin
	vesktop-bin discord keychain zed opencode
	mpv yt-dlp steam lutris gamemode mangohud typora sddm-silent-theme nautilus-dropbox
)

install_paru() {
	command -v paru &>/dev/null && return 0
	
	info "Installing paru..."
	
	# Install build dependencies
	sudo pacman -S --needed --noconfirm base-devel git
	
	local tmp=$(mktemp -d)
	trap "rm -rf '$tmp'" EXIT
	
	git clone https://aur.archlinux.org/paru.git "$tmp/paru" --depth 1 || {
		err "Failed to clone paru"
		trap - EXIT
		return 1
	}
	
	(cd "$tmp/paru" && makepkg -si --noconfirm) || {
		err "Failed to build paru"
		trap - EXIT
		return 1
	}
	
	trap - EXIT
	rm -rf "$tmp"
	
	command -v paru &>/dev/null || { err "paru not found after install"; return 1; }
	ok "paru installed"
}

do_install() {
	local official=() aur=()

	for pkg in "$@"; do
		[[ -z "$pkg" ]] && continue
		if pkg_installed "$pkg"; then
			ok "$pkg"
		elif pacman -Si "$pkg" &>/dev/null; then
			official+=("$pkg")
		elif paru -Si "$pkg" &>/dev/null 2>&1; then
			aur+=("$pkg")
		else
			warn "$pkg not found"
		fi
	done

	if [[ ${#official[@]} -gt 0 ]]; then
		echo
		info "Installing ${#official[@]} official packages..."
		sudo pacman -S --needed --noconfirm "${official[@]}"
	fi

	if [[ ${#aur[@]} -gt 0 ]]; then
		echo
		info "Installing ${#aur[@]} AUR packages..."
		paru --skipreview --needed --noconfirm -S "${aur[@]}" 2>/dev/null || true
	fi
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
}

step "Installing packages"

install_paru || exit 1
do_install "${packages[@]}"
ask_applications

if command -v npm &>/dev/null; then
	info "Installing live-server..."
	sudo npm install -g live-server &>/dev/null && ok "live-server" || warn "live-server failed (non-fatal)"
fi
