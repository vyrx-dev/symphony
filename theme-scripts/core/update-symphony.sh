#!/bin/bash

# Symphony: Complete theme file mirror system
# Creates a live view of the current theme + quick access to all themes

THEMES_DIR="$HOME/dotfiles/themes"
SYMPHONY_DIR="$HOME/.config/symphony"
CURRENT_THEME_FILE="$HOME/.current-theme"

# Get current theme
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "matugen")

update_symphony() {
  echo "🎵 Updating Symphony..."
  
  # Create symphony directory structure
  mkdir -p "$SYMPHONY_DIR/current"
  mkdir -p "$SYMPHONY_DIR/themes"
  
  # Step 1: Update themes directory (symlink to all theme directories)
  echo "📁 Updating themes directory..."
  
  # Clean old theme symlinks
  find "$SYMPHONY_DIR/themes" -type l -delete 2>/dev/null
  
  # Create symlinks for all themes
  for theme_dir in "$THEMES_DIR"/*/; do
    theme_name=$(basename "$theme_dir")
    [ "$theme_name" = "matugen" ] && continue  # Skip matugen
    
    ln -sf "$theme_dir" "$SYMPHONY_DIR/themes/$theme_name"
  done
  
  # Add matugen if it exists
  if [ -d "$THEMES_DIR/matugen" ]; then
    ln -sf "$THEMES_DIR/matugen" "$SYMPHONY_DIR/themes/matugen"
  fi
  
  # Step 2: Update current directory (flat file structure - only actual config files)
  echo "🎨 Mirroring current theme: $CURRENT_THEME"
  
  # Clean current directory
  rm -rf "$SYMPHONY_DIR/current"
  mkdir -p "$SYMPHONY_DIR/current"
  
  CURRENT_THEME_DIR="$THEMES_DIR/$CURRENT_THEME"
  
  if [ ! -d "$CURRENT_THEME_DIR" ]; then
    echo "⚠ Theme directory not found: $CURRENT_THEME_DIR"
    return 1
  fi
  
  # Create flat structure with descriptive names
  # Format: appname-filename.ext (e.g., kitty-colors.conf, alacritty-colors.toml)
  
  cd "$CURRENT_THEME_DIR" || return 1
  
  # Find all files (not directories) and create flat symlinks
  find . -type f | while IFS= read -r file; do
    # Remove leading ./
    clean_path="${file#./}"
    
    # Skip hidden directory markers and parent refs
    [[ "$clean_path" == "." || "$clean_path" == ".." ]] && continue
    
    # Get directory and filename
    dir_path=$(dirname "$clean_path")
    filename=$(basename "$clean_path")
    
    # Create descriptive flat name
    # Example: .config/kitty/colors.conf -> kitty-colors.conf
    #          .cache/wal/colors.json -> wal-colors.json
    #          backgrounds/wall.png -> wall.png
    
    if [[ "$dir_path" == "." ]]; then
      # File in root - keep as is
      flat_name="$filename"
    elif [[ "$dir_path" == ".config/"* ]]; then
      # Config files - format: appname-filename
      app_path="${dir_path#.config/}"
      app_name=$(echo "$app_path" | tr '/' '-')
      flat_name="${app_name}-${filename}"
    elif [[ "$dir_path" == ".cache/"* ]]; then
      # Cache files - format: cachetype-filename
      cache_path="${dir_path#.cache/}"
      cache_name=$(echo "$cache_path" | tr '/' '-')
      flat_name="${cache_name}-${filename}"
    elif [[ "$dir_path" == "backgrounds"* ]]; then
      # Background images - keep filename only
      flat_name="$filename"
    else
      # Other files - flatten path
      flat_name=$(echo "$clean_path" | tr '/' '-')
    fi
    
    # Create symlink with flat name
    ln -sf "$CURRENT_THEME_DIR/$clean_path" "$SYMPHONY_DIR/current/$flat_name"
  done
  
  echo "✅ Symphony updated successfully!"
  echo "   Current theme: $CURRENT_THEME"
  echo "   Location: $SYMPHONY_DIR"
  echo "   Files: $(find "$SYMPHONY_DIR/current" -type l | wc -l) config files"
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  update_symphony "$@"
fi
