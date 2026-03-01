#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Post-Install Setup  |-/ /--|#
#|/ /---+---------------------+/ /---|#

SYMPHONY_DIR="${SYMPHONY_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$SYMPHONY_DIR/install/utils.sh"

# ╭───────────────────────────────────────────────────────────────────────╮
# │ SDDM Silent Theme                                                    │
# ╰───────────────────────────────────────────────────────────────────────╯

setup_sddm() {
    pkg_installed sddm-silent-theme || return 0

    echo
    confirm "Setup minimal SDDM login screen? (sddm-silent-theme)" || return 0

    step "Configuring SDDM"

    # Write sddm.conf
    info "Writing /etc/sddm.conf (requires sudo)"
    sudo tee /etc/sddm.conf > /dev/null << 'SDDM_EOF'
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
SDDM_EOF

    sudo systemctl enable sddm 2>/dev/null || true
    ok "SDDM configured with silent theme"
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Keyd — Capslock → Escape/Control                                     │
# ╰───────────────────────────────────────────────────────────────────────╯

setup_keyd() {
    pkg_installed keyd || return 0

    echo
    info "keyd can remap Capslock → Escape (tap) / Control (hold)"
    info "  This is useful for Vim — tap Caps for Esc, hold for Ctrl"
    confirm "Enable keyd capslock remap?" || return 0

    step "Configuring keyd"

    sudo mkdir -p /etc/keyd
    sudo tee /etc/keyd/default.conf > /dev/null << 'KEYD_EOF'
[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
capslock = overload(control, esc)

# Remaps the escape key to capslock
esc = capslock
KEYD_EOF

    sudo systemctl enable keyd --now 2>/dev/null || true
    ok "keyd enabled — Capslock is now Esc/Ctrl"
}

# ╭───────────────────────────────────────────────────────────────────────╮
# │ Run                                                                   │
# ╰───────────────────────────────────────────────────────────────────────╯

setup_sddm
setup_keyd
