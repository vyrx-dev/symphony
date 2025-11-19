#!/bin/bash

# Theme Switcher with Stow
# Flexible system: colors mandatory, overrides optional per theme

THEMES_DIR="$HOME/dotfiles/themes"
CURRENT_THEME_FILE="$HOME/.current-theme"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# Get current theme
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "matugen")

# Build theme list
get_themes() {
  echo "matugen"
  find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "matugen" ! -name "Wallpapers" ! -name "omarchy" -exec basename {} \; | sort
}

# Rofi menu
if [ -f "$ROFI_CONFIG" ]; then
  SELECTED=$(get_themes | rofi -i -dmenu -p "Select Theme" -config "$ROFI_CONFIG")
else
  SELECTED=$(get_themes | rofi -i -dmenu -p "Select Theme")
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
  
  # Save selected theme
  echo "$SELECTED" >"$CURRENT_THEME_FILE"
  
  # Update Symphony current directory - mirror entire theme structure
  SYMPHONY_CURRENT="$HOME/.config/symphony/current"
  
  # Remove old current directory and recreate
  rm -rf "$SYMPHONY_CURRENT"
  mkdir -p "$SYMPHONY_CURRENT"
  
  # Symlink entire theme directory structure to current
  if [ -d "$THEMES_DIR/$SELECTED" ]; then
    # Create symlinks for all subdirectories and files
    find "$THEMES_DIR/$SELECTED" -mindepth 1 -maxdepth 1 | while read -r item; do
      item_name=$(basename "$item")
      ln -sf "$item" "$SYMPHONY_CURRENT/$item_name"
    done
  fi
  
  # Save current theme name
  echo "$SELECTED" > "$HOME/.config/symphony/.current-theme"
  
  # Manually symlink rofi colors (since main rofi config is not in themes)
  if [ "$SELECTED" = "matugen" ]; then
    # Remove symlink for matugen - it writes directly to this file
    rm -f "$HOME/.config/rofi/colors.rasi"
  elif [ -f "$THEMES_DIR/$SELECTED/.config/rofi/colors.rasi" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/rofi/colors.rasi" "$HOME/.config/rofi/colors.rasi"
  fi
  
  # Manually symlink starship config for non-matugen themes
  if [ "$SELECTED" != "matugen" ] && [ -f "$THEMES_DIR/$SELECTED/.config/starship.toml" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/starship.toml" "$HOME/.config/starship.toml"
  fi
  
  # Manually symlink hyprland theme files (since main hyprland.conf is not in themes)
  mkdir -p "$HOME/.config/hypr/theme"
  if [ -f "$THEMES_DIR/$SELECTED/.config/hypr/theme/colors.conf" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/hypr/theme/colors.conf" "$HOME/.config/hypr/theme/colors.conf"
  fi
  if [ -f "$THEMES_DIR/$SELECTED/.config/hypr/theme/overrides.conf" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/hypr/theme/overrides.conf" "$HOME/.config/hypr/theme/overrides.conf"
  fi
  
  # Manually symlink kitty theme files
  if [ -f "$THEMES_DIR/$SELECTED/.config/kitty/colors.conf" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/kitty/colors.conf" "$HOME/.config/kitty/colors.conf"
  fi
  if [ -f "$THEMES_DIR/$SELECTED/.config/kitty/overrides.conf" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/kitty/overrides.conf" "$HOME/.config/kitty/overrides.conf"
  fi
  
  # Manually symlink alacritty theme files
  if [ -f "$THEMES_DIR/$SELECTED/.config/alacritty/colors.toml" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/alacritty/colors.toml" "$HOME/.config/alacritty/colors.toml"
  fi
  if [ -f "$THEMES_DIR/$SELECTED/.config/alacritty/overrides.toml" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/alacritty/overrides.toml" "$HOME/.config/alacritty/overrides.toml"
  fi
  
  # Manually symlink ghostty theme files
  mkdir -p "$HOME/.config/ghostty/themes"
  if [ "$SELECTED" = "matugen" ]; then
    # Matugen uses themes/colors path
    if [ -f "$THEMES_DIR/$SELECTED/.config/ghostty/themes/colors" ]; then
      ln -sf "$THEMES_DIR/$SELECTED/.config/ghostty/themes/colors" "$HOME/.config/ghostty/themes/colors"
    fi
  else
    # Static themes use theme file (needs to be linked to themes/colors)
    if [ -f "$THEMES_DIR/$SELECTED/.config/ghostty/theme" ]; then
      ln -sf "$THEMES_DIR/$SELECTED/.config/ghostty/theme" "$HOME/.config/ghostty/themes/colors"
    fi
  fi
  
  # Manually symlink btop theme file
  mkdir -p "$HOME/.config/btop/themes"
  if [ -f "$THEMES_DIR/$SELECTED/.config/btop/themes/current.theme" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/btop/themes/current.theme" "$HOME/.config/btop/themes/current.theme"
  fi
  
  # Update cava colors directly in config
  if [ -f "$THEMES_DIR/$SELECTED/.config/cava" ]; then
    "$HOME/dotfiles/theme-scripts/core/update-cava-colors.sh" "$SELECTED" >/dev/null 2>&1
  fi
  
  # Update rmpc theme
  if [ -f "$THEMES_DIR/$SELECTED/.config/rmpc/themes/theme.ron" ] || [ "$SELECTED" = "matugen" ]; then
    "$HOME/dotfiles/theme-scripts/core/update-rmpc-theme.sh" "$SELECTED" >/dev/null 2>&1
  fi
  
  # Update Obsidian theme for all vaults
  bash "$HOME/dotfiles/theme-scripts/core/update-obsidian-theme.sh" >/dev/null 2>&1
  
  # Manually symlink waybar colors (if using waybar)
  if [ -f "$THEMES_DIR/$SELECTED/.config/waybar/colors.css" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/waybar/colors.css" "$HOME/.config/waybar/colors.css"
  fi
  
  # Manually symlink vesktop theme file
  mkdir -p "$HOME/.config/vesktop/themes"
  if [ -f "$THEMES_DIR/$SELECTED/.config/vesktop/themes/midnight-discord.css" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
  fi
  
  # Manually symlink GTK colors for theme-specific coloring
  if [ "$SELECTED" = "matugen" ]; then
    # Remove symlinks for matugen - it writes directly to these files
    rm -f "$HOME/.config/gtk-3.0/colors.css"
    rm -f "$HOME/.config/gtk-4.0/colors.css"
  else
    ln -sf "$THEMES_DIR/$SELECTED/.config/gtk-3.0/colors.css" "$HOME/.config/gtk-3.0/colors.css"
    ln -sf "$THEMES_DIR/$SELECTED/.config/gtk-4.0/colors.css" "$HOME/.config/gtk-4.0/colors.css"
  fi
  
  # Manually symlink pywal colors for Firefox pywalfox integration
  mkdir -p "$HOME/.cache/wal"
  if [ "$SELECTED" = "matugen" ]; then
    # Remove symlink for matugen - it writes directly to this file
    rm -f "$HOME/.cache/wal/colors.json"
  elif [ -f "$THEMES_DIR/$SELECTED/.cache/wal/colors.json" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.cache/wal/colors.json" "$HOME/.cache/wal/colors.json"
  fi
  
  # Manually symlink yazi theme
  if [ -f "$THEMES_DIR/$SELECTED/.config/yazi/theme.toml" ]; then
    ln -sf "$THEMES_DIR/$SELECTED/.config/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
  elif [ "$SELECTED" = "matugen" ]; then
    # Matugen handles yazi theme directly via its config
    :
  fi
  
  # Manually copy neovim theme for hot-reload (copy instead of symlink so LazyVim detects changes)
  if [ -f "$THEMES_DIR/$SELECTED/.config/nvim/theme.lua" ]; then
    cp "$THEMES_DIR/$SELECTED/.config/nvim/theme.lua" "$HOME/.config/nvim/lua/plugins/theme-current.lua"
  elif [ "$SELECTED" = "matugen" ]; then
    # Remove file for matugen (uses default colorscheme.lua)
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
    swww img "$WALLPAPER" --transition-fps 60 --transition-type=any --transition-duration=1
  fi
  
  # Always update wallpaper symlink to whatever swww is currently displaying
  mkdir -p "$HOME/.config/symphony/current"
  CURRENT_WALLPAPER=$(swww query 2>/dev/null | grep "currently displaying" | head -1 | sed 's/.*image: //')
  if [ -n "$CURRENT_WALLPAPER" ]; then
    ln -sf "$CURRENT_WALLPAPER" "$HOME/.config/symphony/current/wallpaper"
  fi

  # Reload all apps
  hyprctl reload 2>/dev/null
  killall -SIGUSR1 kitty 2>/dev/null
  pkill -SIGUSR1 alacritty 2>/dev/null
  pkill -SIGUSR2 btop 2>/dev/null
  pkill -SIGUSR2 waybar 2>/dev/null
  swaync-client -rs 2>/dev/null
  ghostty +reload-config 2>/dev/null
  killall -SIGUSR2 ghostty 2>/dev/null
  
  # Force Starship reload by touching the config file (triggers inotify)
  touch "$HOME/.config/starship.toml" 2>/dev/null

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
