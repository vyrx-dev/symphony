#!/bin/bash
# Simple FZF Queue Selector for RMPC
# Usage: ./queue_selector.sh

# Check if fzf is available
if ! command -v fzf >/dev/null 2>&1; then
  echo "Please install fzf: sudo pacman -S fzf"
  exit 1
fi

# Get current song position for highlighting
current_pos=$(mpc status | grep -o "\[[0-9]*/" | tr -d '[/')

# Select and play
selected=$(
  mpc playlist -f "%position%.%title%" |
    fzf --prompt="🎵 Select song: " \
      --header='' \
      --height=40% \
      --reverse \
      --highlight-line \
      --info=inline \
      --preview-window=up:1
)

if [ -n "$selected" ]; then
  pos=$(echo "$selected" | cut -d'.' -f1)
  echo "🎶 Playing: $(echo "$selected" | cut -d'.' -f2-)"
  mpc play $pos
fi
