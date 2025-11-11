#!/bin/bash

APPS_DIR="$HOME/.local/share/applications"
ICON_DIR="$APPS_DIR/icons"

# Find all webapp desktop files (created by webapp-install.sh)
mapfile -t DESKTOP_FILES < <(find "$APPS_DIR" -maxdepth 1 -name "*.desktop" -type f)

if [[ ${#DESKTOP_FILES[@]} -eq 0 ]]; then
  echo "No webapps found."
  exit 0
fi

# Extract app names for display
APP_NAMES=()
for file in "${DESKTOP_FILES[@]}"; do
  name=$(basename "$file" .desktop)
  APP_NAMES+=("$name")
done

# Let user select apps to remove (multi-select with space, confirm with enter)
SELECTED=$(printf '%s\n' "${APP_NAMES[@]}" | gum choose --no-limit --header "Select webapps to remove (Space to select, Enter to confirm)")

if [[ -z "$SELECTED" ]]; then
  echo "No apps selected."
  exit 0
fi

# Remove selected apps
while IFS= read -r app; do
  DESKTOP_FILE="$APPS_DIR/$app.desktop"
  ICON_FILE="$ICON_DIR/$app.png"

  rm -f "$DESKTOP_FILE"
  rm -f "$ICON_FILE"
  echo "Removed: $app"
done <<<"$SELECTED"

echo -e "\nRemoval complete!"
