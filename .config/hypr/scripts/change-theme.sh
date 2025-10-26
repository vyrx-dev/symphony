#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Wallpapers/"
STATE_FILE="$HOME/.current_wallpaper_index"

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort)

# Get number of wallpapers
NUM_WALLPAPERS=${#WALLPAPERS[@]}
if [ "$NUM_WALLPAPERS" -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

if [ -f "$STATE_FILE" ]; then
  INDEX=$(<"$STATE_FILE")
  INDEX=$(((INDEX + 1) % NUM_WALLPAPERS))
else
  INDEX=0
fi

echo "$INDEX" >"$STATE_FILE"

CURRENT_WALLPAPER="${WALLPAPERS[$INDEX]}"

notify-send -i "$CURRENT_WALLPAPER" "Theme changed" "Wallpaper has been updated."
swww img "$CURRENT_WALLPAPER" --transition-type=any --transition-fps 60 --transition-duration=1
# SWWW_PARAMS="--transition-fps 60 --transition-type=any --transition-duration=1"
wal -i "$CURRENT_WALLPAPER"
pywalfox update
pywal-spicetify text
