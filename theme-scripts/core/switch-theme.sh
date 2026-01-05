#!/bin/bash

# Symphony - Theme Switcher
# Main script that switches themes, updates symlinks, and reloads apps
# Usage: ./switch-theme.sh
# https://github.com/vyrx-dev/dotfiles

THEMES_DIR="$HOME/Documents/github/dotfiles/themes"
CURRENT_THEME_FILE="$HOME/.config/symphony/.current-theme"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# Get current theme
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "matugen")

# Build theme list
get_themes() {
  echo "matugen"
  find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "matugen" ! -name "Wallpapers" ! -name "omarchy" -exec basename {} \; | sort
}

# Check if direct switch requested via environment variable
if [ -n "$SYMPHONY_DIRECT_SWITCH" ]; then
  SELECTED="$SYMPHONY_DIRECT_SWITCH"
else
  # Rofi menu
  if [ -f "$ROFI_CONFIG" ]; then
    SELECTED=$(get_themes | rofi -i -dmenu -p "Select Theme" -config "$ROFI_CONFIG")
  else
    SELECTED=$(get_themes | rofi -i -dmenu -p "Select Theme")
  fi
fi

# Exit if nothing selected
[ -z "$SELECTED" ] && exit 0

# Exit if same theme
[ "$SELECTED" = "$CURRENT_THEME" ] && {
  notify-send "Theme" "Already using $SELECTED"
  exit 0
}

# Switch themes
if [ "$SELECTED" = "matugen" ] || [ -d "$THEMES_DIR/$SELECTED" ]; then
  # Temporarily disable Hyprland's auto-reload to prevent errors during theme switching
  hyprctl keyword misc:disable_autoreload 1 >/dev/null 2>&1

  # Save selected theme (using symphony location as primary)
  mkdir -p "$(dirname "$CURRENT_THEME_FILE")"
  echo "$SELECTED" >"$CURRENT_THEME_FILE"
  # Also write to legacy location for backward compatibility
  echo "$SELECTED" >"$HOME/.current-theme"

  # Update Symphony directory structure
  SYMPHONY_DIR="$HOME/.config/symphony"
  SYMPHONY_CURRENT="$SYMPHONY_DIR/current"
  SYMPHONY_THEMES="$SYMPHONY_DIR/themes"

  # Create symphony directory
  mkdir -p "$SYMPHONY_DIR"

  # Create themes directory with symlinks to all themes
  rm -rf "$SYMPHONY_THEMES"
  mkdir -p "$SYMPHONY_THEMES"

  # Symlink all theme directories to symphony/themes
  for theme_path in "$THEMES_DIR"/*; do
    if [ -d "$theme_path" ]; then
      theme_name=$(basename "$theme_path")
      ln -sf "$theme_path" "$SYMPHONY_THEMES/$theme_name"
    fi
  done

  # Make symphony/current a direct symlink to the active theme directory
  rm -rf "$SYMPHONY_CURRENT"
  ln -sf "$THEMES_DIR/$SELECTED" "$SYMPHONY_CURRENT"

  # Symlink app configs to symphony/current (single source of truth)
  # This way we only update symphony/current when switching themes

  # Rofi colors
  if [ -f "$SYMPHONY_CURRENT/.config/rofi/colors.rasi" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/rofi/colors.rasi" "$HOME/.config/rofi/colors.rasi"
  fi

  # Starship config
  if [ -f "$SYMPHONY_CURRENT/.config/starship.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/starship.toml" "$HOME/.config/starship.toml"
  fi

  # Hyprland theme files
  mkdir -p "$HOME/.config/hypr/theme"
  if [ -f "$SYMPHONY_CURRENT/.config/hypr/theme/colors.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/hypr/theme/colors.conf" "$HOME/.config/hypr/theme/colors.conf"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/hypr/theme/overrides.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/hypr/theme/overrides.conf" "$HOME/.config/hypr/theme/overrides.conf"
  fi

  # Kitty theme files
  if [ -f "$SYMPHONY_CURRENT/.config/kitty/colors.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/kitty/colors.conf" "$HOME/.config/kitty/colors.conf"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/kitty/overrides.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/kitty/overrides.conf" "$HOME/.config/kitty/overrides.conf"
  fi

  # Alacritty theme files
  if [ -f "$SYMPHONY_CURRENT/.config/alacritty/colors.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/alacritty/colors.toml" "$HOME/.config/alacritty/colors.toml"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/alacritty/overrides.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/alacritty/overrides.toml" "$HOME/.config/alacritty/overrides.toml"
  fi

  # Ghostty theme files
  mkdir -p "$HOME/.config/ghostty/themes"
  if [ -f "$SYMPHONY_CURRENT/.config/ghostty/themes/colors" ]; then
    # Matugen uses themes/colors path
    ln -sf "$SYMPHONY_CURRENT/.config/ghostty/themes/colors" "$HOME/.config/ghostty/themes/colors"
  elif [ -f "$SYMPHONY_CURRENT/.config/ghostty/theme" ]; then
    # Static themes use theme file (needs to be linked to themes/colors)
    ln -sf "$SYMPHONY_CURRENT/.config/ghostty/theme" "$HOME/.config/ghostty/themes/colors"
  fi

  # Btop theme file
  mkdir -p "$HOME/.config/btop/themes"
  if [ -f "$SYMPHONY_CURRENT/.config/btop/themes/current.theme" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/btop/themes/current.theme" "$HOME/.config/btop/themes/current.theme"
  fi

  # Update cava colors directly in config
  if [ -f "$SYMPHONY_CURRENT/.config/cava/colors.ini" ] || [ -f "$SYMPHONY_CURRENT/.config/cava" ]; then
    "$HOME/Documents/github/dotfiles/theme-scripts/core/update-cava-colors.sh" "$SELECTED" >/dev/null 2>&1
  fi

  # Update rmpc theme
  if [ -f "$SYMPHONY_CURRENT/.config/rmpc/themes/theme.ron" ] || [ -f "$SYMPHONY_CURRENT/.config/rmpc/themes/current.ron" ]; then
    "$HOME/Documents/github/dotfiles/theme-scripts/core/update-rmpc-theme.sh" "$SELECTED" >/dev/null 2>&1
  fi

  # Update Obsidian theme for all vaults
  bash "$HOME/Documents/github/dotfiles/theme-scripts/core/update-obsidian-theme.sh" >/dev/null 2>&1

  # Waybar colors
  if [ -f "$SYMPHONY_CURRENT/.config/waybar/colors.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/waybar/colors.css" "$HOME/.config/waybar/colors.css"
  fi

  # Vesktop theme file
  mkdir -p "$HOME/.config/vesktop/themes"
  if [ -f "$SYMPHONY_CURRENT/.config/vesktop/themes/midnight-discord.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
  fi

  # GTK colors
  if [ -f "$SYMPHONY_CURRENT/.config/gtk-3.0/colors.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/gtk-3.0/colors.css" "$HOME/.config/gtk-3.0/colors.css"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/gtk-4.0/colors.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/gtk-4.0/colors.css" "$HOME/.config/gtk-4.0/colors.css"
  fi

  # Pywal colors for Firefox pywalfox integration
  mkdir -p "$HOME/.cache/wal"
  if [ -f "$SYMPHONY_CURRENT/.cache/wal/colors.json" ]; then
    ln -sf "$SYMPHONY_CURRENT/.cache/wal/colors.json" "$HOME/.cache/wal/colors.json"
  fi

  # Yazi theme
  if [ -f "$SYMPHONY_CURRENT/.config/yazi/theme.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
  fi

  # Copy neovim theme for hot-reload (copy instead of symlink so LazyVim detects changes)
  if [ -f "$SYMPHONY_CURRENT/.config/nvim/theme.lua" ]; then
    cp "$SYMPHONY_CURRENT/.config/nvim/theme.lua" "$HOME/.config/nvim/lua/plugins/theme-current.lua"
  else
    # Remove file if theme doesn't have nvim theme (uses default colorscheme.lua)
    rm -f "$HOME/.config/nvim/lua/plugins/theme-current.lua"
  fi

  # Re-enable auto-reload
  hyprctl keyword misc:disable_autoreload 0 >/dev/null 2>&1

  # Apply GTK dark theme using nwg-look (reads from gsettings and applies properly)
  nwg-look -a >/dev/null 2>&1

  # Get wallpaper if theme has one (sorted for consistency)
  WALLPAPER=$(find "$THEMES_DIR/$SELECTED/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | sort | head -1)

  # Set wallpaper if exists
  if [ -n "$WALLPAPER" ]; then
    swww query &>/dev/null || swww-daemon --format xrgb &
    swww img "$WALLPAPER" \
  --transition-type center \
  --transition-pos top-right \
  --transition-fps 120 \
  --transition-duration 1 \
  --transition-bezier 0.25,0.1,0.25,1.0
  fi

  # Always update wallpaper symlink to whatever swww is currently displaying
  # This creates a symlink in the theme directory itself
  CURRENT_WALLPAPER=$(swww query 2>/dev/null | grep "currently displaying" | head -1 | sed 's/.*image: //')
  if [ -n "$CURRENT_WALLPAPER" ]; then
    ln -sf "$CURRENT_WALLPAPER" "$THEMES_DIR/$SELECTED/wallpaper"
  fi

  # Reload all apps
  hyprctl reload
  killall -SIGUSR1 kitty
  pkill -SIGUSR1 alacritty
  pkill -SIGUSR2 btop
  pkill -SIGUSR2 waybar
  ghostty +reload-config
  killall -SIGUSR2 ghostty

  # Restart OSD service
  "$HOME/Documents/github/dotfiles/scripts/restart-app" swayosd-server

  # Force Starship reload by touching the config file (triggers inotify)
  touch "$HOME/.config/starship.toml"

  # Reload GTK apps
  pgrep -x nautilus >/dev/null && (
    pkill -x nautilus && nautilus &>/dev/null &
    disown
  )

  # Update Firefox pywalfox colors automatically
  pywalfox update >/dev/null 2>&1 &

  # Send notification
  if [ -n "$WALLPAPER" ]; then
    notify-send -i "$WALLPAPER" "Theme Applied" "Switched to: $SELECTED"
  else
    notify-send "Theme Applied" "Switched to: $SELECTED"
  fi
else
  notify-send "Error" "Theme not found: $SELECTED"
  exit 1
fi
