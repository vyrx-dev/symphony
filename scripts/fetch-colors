#!/bin/bash

set -euo pipefail

# This script displays the 16 standard ANSI colors (0-15) as large squares
# in two rows: first row shows colors 0-7, second row shows colors 8-15

echo ""

# First row: ANSI colors 0-7 (dark colors)
for row in {1..4}; do
  for color in {0..7}; do
    printf "\e[38;5;${color}m\e[48;5;${color}m████████\e[0m  "
  done
  echo ""
done
echo ""

# Second row: ANSI colors 8-15 (bright colors)
for row in {1..4}; do
  for color in {8..15}; do
    printf "\e[38;5;${color}m\e[48;5;${color}m████████\e[0m  "
  done
  echo ""
done

echo ""
