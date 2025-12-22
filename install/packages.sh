#!/bin/bash
# Package installation

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Core Packages                                                         │
# ╰───────────────────────────────────────────────────────────────────────╯

packages=(
    base-devel                  # build tools
    git                         # version control
    stow                        # symlink manager

    # Hyprland
    hyprland                    # compositor
    hypridle                    # idle daemon
    hyprlock                    # lock screen
    hyprpicker                  # color picker
    hyprsunset                  # blue light filter
    xdg-desktop-portal-hyprland # screen sharing
    xdg-desktop-portal-gtk      # file picker
    qt5-wayland                 # Qt5 wayland
    qt6-wayland                 # Qt6 wayland
    uwsm                        # session manager

    # Desktop
    waybar                      # status bar
    rofi                        # launcher
    swaync                      # notifications
    swayosd                     # OSD
    swww                        # wallpaper
    wlogout                     # logout menu

    # Terminal
    kitty                       # primary
    alacritty                   # screensaver

    # Shell
    fish                        # shell
    starship                    # prompt
    tmux                        # multiplexer

    # CLI
    eza                         # ls
    bat                         # cat
    fd                          # find
    ripgrep                     # grep
    fzf                         # fuzzy finder
    zoxide                      # smart cd
    jq                          # JSON

    # Files
    yazi                        # TUI file manager
    nautilus                    # GUI file manager

    # Dev
    neovim                      # editor
    lazygit                     # git TUI

    # Screenshot
    grim                        # screenshot
    slurp                       # region select
    satty                       # annotation
    wl-clipboard                # clipboard
    gpu-screen-recorder         # recording
    ffmpeg                      # video
    v4l-utils                   # webcam

    # Clipboard
    cliphist                    # history
    wl-clip-persist             # persist

    # Audio
    pipewire                    # server
    pipewire-alsa               # ALSA
    pipewire-pulse              # PulseAudio
    pipewire-jack               # JACK
    wireplumber                 # session
    pamixer                     # CLI mixer
    pavucontrol                 # GUI mixer
    wiremix                     # TUI mixer

    # Music
    mpd                         # daemon
    mpc                         # CLI
    rmpc                        # TUI
    cava                        # visualizer
    playerctl                   # MPRIS

    # Network
    networkmanager              # network
    network-manager-applet      # tray
    impala                      # wifi TUI

    # Bluetooth
    bluez                       # stack
    bluez-utils                 # CLI
    blueberry                   # GUI

    # System
    polkit-gnome                # auth
    brightnessctl               # brightness
    ddcutil                     # monitor
    power-profiles-daemon       # power
    libnotify                   # notify-send
    xdg-utils                   # xdg-open
    xdg-user-dirs               # user dirs
    inotify-tools               # fs monitor

    # Theming
    matugen-bin                 # wallpaper colors
    nwg-look                    # GTK settings
    adw-gtk-theme               # GTK3 theme
    bibata-cursor-theme-bin     # cursor

    # Rofi
    rofimoji                    # emoji
    wtype                       # keyboard

    # Monitor
    btop                        # system
    fastfetch                   # info

    # Fonts
    ttf-jetbrains-mono-nerd     # mono
    ttf-cascadia-mono-nerd      # alt mono
    noto-fonts-emoji            # emoji

    # Display
    sddm                        # login
    qt5-quickcontrols           # sddm deps
    qt5-quickcontrols2
    qt5-graphicaleffects

    # Misc
    python-terminaltexteffects  # tte
    gum                         # prompts
    wget                        # download
    curl                        # HTTP
    unzip                       # archive
    localsend-bin               # file share
)

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Optional Applications                                                 │
# ╰───────────────────────────────────────────────────────────────────────╯

applications=(
    brave-bin                   # browser
    zen-browser-bin             # firefox fork
    firefox
    chromium
    obsidian                    # notes
    bitwarden                   # passwords
    code                        # vscode OSS
    visual-studio-code-bin      # vscode
    vesktop-bin                 # discord
    discord
    spotify-launcher
    spicetify-cli               # spotify theme
    mpv                         # video
    yt-dlp                      # youtube
    steam                       # gaming
    lutris                      # games
    gamemode                    # performance
    mangohud                    # overlay
)

# ─────────────────────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────────────────────

setup_aur() {
    aur_installed && return 0

    info "Installing yay..."
    local tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin" --depth 1 >/dev/null 2>&1
    (cd "$tmp/yay-bin" && makepkg -si --noconfirm) >/dev/null 2>&1
    rm -rf "$tmp"
    ok "yay"
    return 0
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
        elif $aur -Si "$pkg" &>/dev/null; then
            from_aur+=("$pkg")
        else
            warn "$pkg (not found)"
        fi
    done

    [[ ${#official[@]} -gt 0 ]] && {
        info "Installing ${#official[@]} from official repos..."
        sudo pacman -S --needed --noconfirm "${official[@]}" >/dev/null 2>&1
        for pkg in "${official[@]}"; do ok "$pkg"; done
    }

    [[ ${#from_aur[@]} -gt 0 ]] && {
        info "Installing ${#from_aur[@]} from AUR..."
        $aur -S --needed --noconfirm "${from_aur[@]}" >/dev/null 2>&1
        for pkg in "${from_aur[@]}"; do ok "$pkg"; done
    }
    return 0
}

ask_applications() {
    command -v gum &>/dev/null || return 0

    echo
    gum confirm "Install optional applications?" || return 0

    local selected=$(printf '%s\n' "${applications[@]}" | gum choose --no-limit --height 20)
    [[ -z "$selected" ]] && return 0

    step "Installing applications"
    do_install $selected
    return 0
}

# ─────────────────────────────────────────────────────────────────────────────
# Run
# ─────────────────────────────────────────────────────────────────────────────

step "Installing packages"
setup_aur
do_install "${packages[@]}"
ask_applications
