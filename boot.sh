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
echo -e "${DIM}  Preparing system...${RESET}"
sudo pacman -Syu --noconfirm --needed git stow gum >/dev/null 2>&1
echo -e "${GREEN}  ✓${RESET} Dependencies ready"

# Clone or update
if [[ -d "$DEST/.git" ]]; then
    echo -e "${DIM}  Updating dotfiles...${RESET}"
    git -C "$DEST" pull --ff-only >/dev/null 2>&1 || true
else
    echo -e "${DIM}  Cloning dotfiles...${RESET}"
    rm -rf "$DEST"
    git clone "https://github.com/${REPO}.git" "$DEST" --depth 1 >/dev/null 2>&1
fi

# Switch branch if needed
if [[ "$BRANCH" != "main" ]]; then
    git -C "$DEST" fetch origin "$BRANCH" --depth 1 >/dev/null 2>&1
    git -C "$DEST" checkout "$BRANCH" >/dev/null 2>&1
fi

echo -e "${GREEN}  ✓${RESET} Repository ready"
echo

cd "$DEST"
source ./install.sh
