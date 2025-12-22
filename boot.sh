#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Bootstrap Script    |-/ /--|#
#|/ /---+---------------------+/ /---|#

set -e

# Colors
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
DIM='\033[2m'
RESET='\033[0m'

clear
echo -e "${MAGENTA}"
cat << 'EOF'

        ♪                                            ♫
   ▄▄▄▄▄                                         ♪
  ██▀▀▀▀█▄                      █▄           ♬
  ▀██▄  ▄▀       ▄              ██          ▄
    ▀██▄▄  ██ ██ ███▄███▄ ████▄ ████▄ ▄███▄ ████▄ ██ ██
  ▄   ▀██▄ ██▄██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██▄██
  ▀██████▀▄▄▀██▀▄██ ██ ▀█▄████▀▄██ ██▄▀███▀▄██ ▀█▄▄▀██▀
     ♫       ██           ██                        ██
           ▀▀▀     ♪      ▀              ♬        ▀▀▀

EOF
echo -e "${RESET}"

REPO="${SYMPHONY_REPO:-vyrx-dev/dotfiles}"
BRANCH="${SYMPHONY_BRANCH:-main}"
DEST="${SYMPHONY_DEST:-$HOME/dotfiles}"

# Bootstrap dependencies
echo -e "\n${DIM}:: Preparing system${RESET}"
sudo pacman -Syu --noconfirm --needed git stow gum

# Clone or update
echo
if [[ -d "$DEST/.git" ]]; then
    echo -e "${DIM}  Updating dotfiles...${RESET}"
    git -C "$DEST" pull --ff-only || true
else
    echo -e "${DIM}  Cloning from github.com/${REPO}...${RESET}"
    rm -rf "$DEST"
    git clone "https://github.com/${REPO}.git" "$DEST"
fi

# Switch branch if needed
if [[ "$BRANCH" != "main" ]]; then
    git -C "$DEST" fetch origin "$BRANCH"
    git -C "$DEST" checkout "$BRANCH"
fi

# Verify clone worked
if [[ ! -f "$DEST/install.sh" ]]; then
    echo -e "\n${MAGENTA}  ✗${RESET} Clone failed - install.sh not found"
    exit 1
fi

echo -e "${GREEN}  ✓${RESET} Repository ready"
echo

cd "$DEST"
source ./install.sh
