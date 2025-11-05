#!/bin/bash

# Generate kitty.conf theme from omarchy theme colors
# This script reads colors from btop.theme and creates kitty.conf

THEME_DIR="$1"
OUTPUT_FILE="${2:-$THEME_DIR/kitty.conf}"

if [[ -z "$THEME_DIR" ]]; then
  echo "Usage: omarchy-generate-kitty-theme <theme_directory> [output_file]" >&2
  exit 1
fi

BTOP_THEME="$THEME_DIR/btop.theme"

if [[ ! -f "$BTOP_THEME" ]]; then
  echo "Theme colors not found: $BTOP_THEME" >&2
  exit 1
fi

# Extract colors from btop.theme
main_bg=$(grep 'theme\[main_bg\]' "$BTOP_THEME" | sed 's/.*="\(#[^"]*\)".*/\1/')
main_fg=$(grep 'theme\[main_fg\]' "$BTOP_THEME" | sed 's/.*="\(#[^"]*\)".*/\1/')
selected_bg=$(grep 'theme\[selected_bg\]' "$BTOP_THEME" | sed 's/.*="\(#[^"]*\)".*/\1/')
hi_fg=$(grep 'theme\[hi_fg\]' "$BTOP_THEME" | sed 's/.*="\(#[^"]*\)".*/\1/')
inactive_fg=$(grep 'theme\[inactive_fg\]' "$BTOP_THEME" | sed 's/.*="\(#[^"]*\)".*/\1/')

# Fallback to alacritty if btop colors are insufficient
if [[ -z "$main_bg" || -z "$main_fg" ]] && [[ -f "$THEME_DIR/alacritty.toml" ]]; then
  echo "# Using alacritty.toml as fallback for missing colors"
  main_bg=$(grep -A3 '\[colors.primary\]' "$THEME_DIR/alacritty.toml" | grep 'background' | sed 's/.*= *.\(#[0-9a-fA-F]*\).*/\1/')
  main_fg=$(grep -A3 '\[colors.primary\]' "$THEME_DIR/alacritty.toml" | grep 'foreground' | sed 's/.*= *.\(#[0-9a-fA-F]*\).*/\1/')
fi

# Generate kitty.conf
cat >"$OUTPUT_FILE" <<EOF
# Kitty theme auto-generated from omarchy theme
# Based on: $(basename "$THEME_DIR")
# Basic colors
foreground $main_fg
background $main_bg
# Cursor
cursor $hi_fg
cursor_text_color $main_bg
# Selection
selection_foreground $main_fg
selection_background $selected_bg
# Tab bar colors
tab_bar_background $main_bg
active_tab_foreground $main_fg
active_tab_background $selected_bg
inactive_tab_foreground $inactive_fg
inactive_tab_background $main_bg
EOF

# If alacritty.toml exists, extract the 16 terminal colors from it
if [[ -f "$THEME_DIR/alacritty.toml" ]]; then
  echo "" >>"$OUTPUT_FILE"
  echo "# Terminal colors from alacritty theme" >>"$OUTPUT_FILE"

  # Normal colors (0-7)
  colors=("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white")
  for i in "${!colors[@]}"; do
    color=$(grep -A8 '\[colors.normal\]' "$THEME_DIR/alacritty.toml" | grep "^${colors[i]}" | sed 's/.*= *.\(#[0-9a-fA-F]*\).*/\1/')
    echo "color$i $color" >>"$OUTPUT_FILE"
  done

  # Bright colors (8-15)
  for i in "${!colors[@]}"; do
    bright_color=$(grep -A8 '\[colors.bright\]' "$THEME_DIR/alacritty.toml" | grep "^${colors[i]}" | sed 's/.*= *.\(#[0-9a-fA-F]*\).*/\1/')
    echo "color$((i + 8)) $bright_color" >>"$OUTPUT_FILE"
  done
else
  echo "# Note: No terminal colors available - using theme defaults" >>"$OUTPUT_FILE"
fi

echo "Generated kitty theme: $OUTPUT_FILE"
