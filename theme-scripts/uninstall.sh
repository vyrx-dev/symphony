#!/bin/bash
#
# Symphony - Uninstaller
# Remove themes or completely uninstall the system
#
# Usage: ./uninstall.sh
# https://github.com/vyrx-dev/dotfiles

set -e

THEMES_DIR="$HOME/dotfiles/themes"
SYMPHONY_DIR="$HOME/.config/symphony"

# Check if gum available
HAS_GUM=false
command -v gum >/dev/null 2>&1 && HAS_GUM=true

show_menu() {
  echo "" >&2
  echo "Symphony Uninstaller" >&2
  echo "" >&2
  echo "1) Delete specific themes" >&2
  echo "2) Complete removal (nuke)" >&2
  echo "3) Cancel" >&2
  echo "" >&2
  read -p "Select: " choice
  echo "$choice"
}

# Delete specific themes
delete_themes() {
  local themes=()
  
  # Get theme list
  for dir in "$THEMES_DIR"/*; do
    [[ -d "$dir" ]] && themes+=("$(basename "$dir")")
  done
  
  if [[ "$HAS_GUM" == true ]]; then
    echo "Select themes to delete (Space: select, Enter: confirm)"
    selected=$(printf '%s\n' "${themes[@]}" | gum choose --no-limit --header="Delete themes:")
  else
    echo ""
    echo "Available themes:"
    for i in "${!themes[@]}"; do
      echo "  $((i+1))) ${themes[$i]}"
    done
    echo ""
    read -p "Enter numbers (space-separated): " nums
    
    selected=""
    for num in $nums; do
      idx=$((num-1))
      [[ $idx -ge 0 && $idx -lt ${#themes[@]} ]] && selected+="${themes[$idx]}"$'\n'
    done
  fi
  
  [[ -z "$selected" ]] && { echo "Nothing selected"; exit 0; }
  
  echo ""
  echo "Will delete:"
  echo "$selected"
  echo ""
  read -p "Confirm? (yes/no): " confirm
  
  if [[ "$confirm" == "yes" ]]; then
    while IFS= read -r theme; do
      [[ -z "$theme" ]] && continue
      rm -rf "$THEMES_DIR/$theme"
      echo "✓ Deleted $theme"
    done <<< "$selected"
    echo ""
    echo "✅ Themes deleted"
  else
    echo "Cancelled"
  fi
}

# Complete removal
nuke_everything() {
  echo ""
  echo "COMPLETE REMOVAL"
  echo ""
  echo "This will remove:"
  echo "  - All themes ($THEMES_DIR)"
  echo "  - Symphony configs ($SYMPHONY_DIR)"
  echo "  - Legacy theme file (~/.current-theme)"
  echo "  - Pywal cache symlink"
  echo ""
  read -p "Type 'yes' to confirm: " confirm
  
  if [[ "$confirm" != "yes" ]]; then
    echo "Cancelled"
    exit 0
  fi
  
  echo ""
  echo "Removing..."
  
  # Remove symphony directory (contains current symlink and themes symlinks)
  rm -rf "$SYMPHONY_DIR"
  echo "Removed symphony config"
  
  # Remove legacy theme file
  rm -f "$HOME/.current-theme"
  echo "Removed legacy theme file"
  
  # Remove pywal symlink
  rm -f "$HOME/.cache/wal/colors.json"
  echo "Removed pywal symlink"
  
  # Remove themes
  rm -rf "$THEMES_DIR"
  echo "Removed themes"
  
  # Remove theme-scripts
  read -p "Remove theme-scripts directory? (yes/no): " remove_scripts
  if [[ "$remove_scripts" == "yes" ]]; then
    rm -rf "$HOME/dotfiles/theme-scripts"
    echo "Removed scripts"
  fi
  
  echo ""
  echo "Complete removal done"
  echo ""
  echo "Manual cleanup needed:"
  echo "  - Remove PATH entry from shell rc file"
  echo "  - Reload shell: source ~/.bashrc or ~/.zshrc"
}

# Main
choice=$(show_menu)

case $choice in
  1) delete_themes ;;
  2) nuke_everything ;;
  3) echo "Cancelled"; exit 0 ;;
  *) echo "Invalid choice"; exit 1 ;;
esac
