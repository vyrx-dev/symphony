#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| User Services       |-/ /--|#
#|/ /---+---------------------+/ /---|#

step "Setting up services"

# Set GTK dark theme via gsettings
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    ok "GTK dark theme"
fi

# MPD user service
if pkg_installed mpd; then
    mkdir -p ~/.config/systemd/user/mpd.service.d
    echo -e "[Service]\nRuntimeDirectory=mpd" > ~/.config/systemd/user/mpd.service.d/override.conf
    systemctl --user daemon-reload
    systemctl --user enable --now mpd && ok "mpd" || warn "mpd failed"
fi

# GNOME Keyring - prevents browser logout after suspend
# Creates an auto-unlock keyring that never locks
if pkg_installed gnome-keyring; then
    keyring_dir="$HOME/.local/share/keyrings"
    keyring_file="$keyring_dir/Default_keyring.keyring"

    if [[ ! -f "$keyring_file" ]]; then
        mkdir -p "$keyring_dir"

        cat > "$keyring_file" << EOF
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
EOF

        echo "Default_keyring" > "$keyring_dir/default"

        chmod 700 "$keyring_dir"
        chmod 600 "$keyring_file"
        chmod 644 "$keyring_dir/default"

        ok "gnome-keyring"
    else
        ok "gnome-keyring (already configured)"
    fi
fi
