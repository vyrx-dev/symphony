#!/bin/bash
# Package installation

packages=(

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Core System                                                           │
    # ╰───────────────────────────────────────────────────────────────────────╯

    base-devel                  # development tools (required for AUR)
    git                         # version control
    stow                        # symlink manager for dotfiles

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Hyprland & Wayland                                                    │
    # ╰───────────────────────────────────────────────────────────────────────╯

    hyprland                    # tiling wayland compositor
    hypridle                    # idle daemon
    hyprlock                    # lock screen
    hyprpicker                  # color picker
    hyprsunset                  # blue light filter
    xdg-desktop-portal-hyprland # screen sharing, file picker
    xdg-desktop-portal-gtk      # GTK file picker fallback
    qt5-wayland                 # Qt5 wayland support
    qt6-wayland                 # Qt6 wayland support
    uwsm                        # session manager

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Desktop                                                               │
    # ╰───────────────────────────────────────────────────────────────────────╯

    waybar                      # status bar
    rofi                        # app launcher (wayland native in 2.0+)
    swaync                      # notification center
    swayosd-git                 # OSD for volume/brightness
    swww                        # wallpaper daemon
    wlogout                     # logout menu

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Terminals                                                             │
    # ╰───────────────────────────────────────────────────────────────────────╯

    kitty                       # primary terminal
    alacritty                   # used for screensaver
    # ghostty                   # alternative

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Shell                                                                 │
    # ╰───────────────────────────────────────────────────────────────────────╯

    fish                        # shell
    starship                    # prompt
    tmux                        # multiplexer

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ CLI Tools                                                             │
    # ╰───────────────────────────────────────────────────────────────────────╯

    eza                         # ls replacement
    bat                         # cat with syntax highlighting
    fd                          # find replacement
    ripgrep                     # grep replacement
    fzf                         # fuzzy finder
    zoxide                      # smart cd
    jq                          # JSON processor

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ File Management                                                       │
    # ╰───────────────────────────────────────────────────────────────────────╯

    yazi                        # terminal file manager
    nautilus                    # GUI file manager

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Development                                                           │
    # ╰───────────────────────────────────────────────────────────────────────╯

    neovim                      # editor
    lazygit                     # git TUI
    # lazydocker                # docker TUI

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Screenshots & Recording                                               │
    # ╰───────────────────────────────────────────────────────────────────────╯

    grim                        # screenshot
    slurp                       # region selector
    satty                       # annotation
    wl-clipboard                # wl-copy, wl-paste
    gpu-screen-recorder         # screen recording
    ffmpeg                      # video processing
    v4l-utils                   # webcam

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Clipboard                                                             │
    # ╰───────────────────────────────────────────────────────────────────────╯

    cliphist                    # clipboard history
    wl-clip-persist             # persist after app closes

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Audio                                                                 │
    # ╰───────────────────────────────────────────────────────────────────────╯

    pipewire                    # audio server
    pipewire-alsa               # ALSA compat
    pipewire-pulse              # PulseAudio compat
    pipewire-jack               # JACK compat
    wireplumber                 # session manager
    pamixer                     # CLI mixer
    pavucontrol                 # GUI mixer
    wiremix                     # TUI mixer

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Music                                                                 │
    # ╰───────────────────────────────────────────────────────────────────────╯

    mpd                         # music daemon
    mpc                         # mpd CLI
    rmpc                        # mpd TUI
    cava                        # visualizer
    playerctl                   # MPRIS control

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Networking                                                            │
    # ╰───────────────────────────────────────────────────────────────────────╯

    networkmanager              # network management
    network-manager-applet      # tray applet
    impala                      # TUI wifi manager

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Bluetooth                                                             │
    # ╰───────────────────────────────────────────────────────────────────────╯

    bluez                       # bluetooth stack
    bluez-utils                 # bluetoothctl
    blueberry                   # GUI manager

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ System                                                                │
    # ╰───────────────────────────────────────────────────────────────────────╯

    polkit-gnome                # auth dialogs
    brightnessctl               # laptop brightness
    ddcutil                     # external monitor brightness
    power-profiles-daemon       # power management
    libnotify                   # notify-send
    xdg-utils                   # xdg-open
    xdg-user-dirs               # ~/Documents, etc.
    inotify-tools               # filesystem monitoring

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Theming                                                               │
    # ╰───────────────────────────────────────────────────────────────────────╯

    matugen-bin                 # colorscheme from wallpaper
    nwg-look                    # GTK settings
    bibata-cursor-theme-bin     # cursor theme

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Rofi                                                                  │
    # ╰───────────────────────────────────────────────────────────────────────╯

    rofimoji                    # emoji picker
    wtype                       # keyboard input

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Monitoring                                                            │
    # ╰───────────────────────────────────────────────────────────────────────╯

    btop                        # system monitor
    fastfetch                   # system info

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Fonts                                                                 │
    # ╰───────────────────────────────────────────────────────────────────────╯

    ttf-jetbrains-mono-nerd     # monospace font
    ttf-cascadia-mono-nerd      # alt monospace
    noto-fonts-emoji            # emoji

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Display Manager                                                       │
    # ╰───────────────────────────────────────────────────────────────────────╯

    sddm                        # login screen
    qt5-quickcontrols           # sddm deps
    qt5-quickcontrols2
    qt5-graphicaleffects

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ Misc                                                                  │
    # ╰───────────────────────────────────────────────────────────────────────╯

    python-terminaltexteffects  # tte animations
    gum                         # interactive prompts
    wget                        # downloader
    curl                        # HTTP client
    unzip                       # archive extraction
    localsend-bin               # file sharing

    # ╭───────────────────────────────────────────────────────────────────────╮
    # │ NVIDIA (uncomment if needed, archinstall usually handles this)        │
    # ╰───────────────────────────────────────────────────────────────────────╯

    # linux-headers             # kernel headers
    # nvidia-dkms               # driver
    # nvidia-utils              # utilities
    # libva-nvidia-driver       # hardware video accel

)

# ─────────────────────────────────────────────────────────────────────────────
# Optional applications
# ─────────────────────────────────────────────────────────────────────────────

applications=(
    # Browsers
    brave-bin                   # privacy browser
    zen-browser-bin             # firefox fork
    firefox
    chromium

    # Productivity
    obsidian                    # notes
    bitwarden                   # passwords
    code                        # vscode OSS
    visual-studio-code-bin      # vscode MS

    # Communication
    vesktop-bin                 # discord + plugins
    discord

    # Media
    spotify-launcher
    spicetify-cli               # spotify theming
    mpv                         # video player
    yt-dlp                      # youtube downloader

    # Gaming
    steam
    lutris                      # game launcher
    gamemode                    # performance
    mangohud                    # overlay
)

# ─────────────────────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────────────────────

install_aur_helper() {
    if aur_installed; then
        ok "AUR helper: $(get_aur_helper)"
        return
    fi

    step "Installing yay"
    local tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin" --depth 1
    (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    ok "yay installed"
}

install_packages() {
    local aur=$(get_aur_helper)
    local official=()
    local from_aur=()

    for pkg in "$@"; do
        [[ -z "$pkg" ]] && continue

        if pkg_installed "$pkg"; then
            ok "$pkg"
        elif pacman -Si "$pkg" &>/dev/null; then
            official+=("$pkg")
            info "$pkg (official)"
        elif $aur -Si "$pkg" &>/dev/null; then
            from_aur+=("$pkg")
            info "$pkg (aur)"
        else
            warn "$pkg (not found)"
        fi
    done

    [[ ${#official[@]} -gt 0 ]] && sudo pacman -S --needed --noconfirm "${official[@]}"
    [[ ${#from_aur[@]} -gt 0 ]] && $aur -S --needed --noconfirm "${from_aur[@]}"
}

ask_applications() {
    command -v gum &>/dev/null || return

    echo
    gum confirm "Install optional applications?" || return

    step "Select applications"
    local selected=$(printf '%s\n' "${applications[@]}" | gum choose --no-limit --height 20)

    [[ -n "$selected" ]] && install_packages $selected
}

# ─────────────────────────────────────────────────────────────────────────────
# Run
# ─────────────────────────────────────────────────────────────────────────────

install_aur_helper

step "Installing packages"
install_packages "${packages[@]}"

ask_applications
