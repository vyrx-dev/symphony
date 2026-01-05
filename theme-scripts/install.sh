#!/bin/bash

# Symphony Theme System Installer
# https://github.com/vyrx-dev/dotfiles

SCRIPT_DIR="$HOME/Documents/github/dotfiles/theme-scripts"
THEMES_DIR="$HOME/Documents/github/dotfiles/themes"

echo "🎵 Symphony Theme System - Installation"
echo ""

# Check if gum is available
HAS_GUM=false
if command -v gum >/dev/null 2>&1; then
  HAS_GUM=true
fi

# Add symphony-theme to PATH (create symlink in ~/.local/bin)
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

if [ ! -f "$LOCAL_BIN/symphony-theme" ]; then
  ln -sf "$SCRIPT_DIR/symphony-theme" "$LOCAL_BIN/symphony-theme"
  echo "✅ Created symphony-theme command in $LOCAL_BIN"
else
  echo "ℹ️  symphony-theme already exists in $LOCAL_BIN"
fi

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  echo ""
  echo "⚠️  Warning: $LOCAL_BIN is not in your PATH"
  echo "   Add this to your shell config:"
  echo "   export PATH=\"\$PATH:\$HOME/.local/bin\""
  echo ""
fi

# Theme selection
echo ""
echo "📦 Available themes:"
themes=()
while IFS= read -r theme; do
  if [ -n "$theme" ]; then
    themes+=("$theme")
    echo "   - $theme"
  fi
done < <(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

if [ ${#themes[@]} -eq 0 ]; then
  echo "   No themes found!"
  exit 1
fi

echo ""
if [ "$HAS_GUM" = true ]; then
  SELECTED=$(printf '%s\n' "${themes[@]}" | gum choose --header "Select a theme to activate:")
else
  echo "Select a theme to activate:"
  select SELECTED in "${themes[@]}"; do
    if [ -n "$SELECTED" ]; then
      break
    fi
  done
fi

if [ -n "$SELECTED" ]; then
  echo ""
  echo "🎨 Switching to theme: $SELECTED"
  "$SCRIPT_DIR/symphony-theme" switch "$SELECTED"
  echo ""
  echo "✅ Installation complete!"
  echo ""
  echo "Next steps:"
  echo "  1. Reload your shell: source ~/.config/fish/config.fish"
  echo "  2. Test: symphony-theme switch"
  echo "  3. Read: ~/Documents/github/dotfiles/theme-scripts/README.md"
else
  echo "❌ No theme selected"
  exit 1
fi

