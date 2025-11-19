#!/bin/bash

# update-obsidian-theme.sh: Bootstrap and update theme for Obsidian vaults
#
# - Ensures registry at ~/.local/state/symphony/obsidian-vaults
#   - Populates by extracting vault paths from ~/.config/obsidian/obsidian.json
# - For each valid vault:
#   - Ensures .obsidian/themes/Symphony/{manifest.json, theme.css}
#   - Updates theme.css (uses current theme's obsidian.css if present; otherwise generates)

VAULTS_FILE="$HOME/.local/state/symphony/obsidian-vaults"
THEMES_DIR="$HOME/dotfiles/themes"
CURRENT_THEME_FILE="$HOME/.current-theme"

# Get current theme name
get_current_theme() {
  cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "matugen"
}

# Get current theme directory path
get_theme_dir() {
  local theme="$1"
  if [ "$theme" = "matugen" ]; then
    echo "$HOME/.config/symphony/current"
  else
    echo "$THEMES_DIR/$theme"
  fi
}

ensure_vaults_file() {
  mkdir -p "$(dirname "$VAULTS_FILE")"
  local tmpfile
  tmpfile="$(mktemp)"
  # Extract the Obsidian vault location from config file <base>/<vault>/.obsidian
  jq -r '.vaults | values[].path' ~/.config/obsidian/obsidian.json 2>/dev/null >>"$tmpfile"
    if [ -s "$tmpfile" ]; then
      sort -u "$tmpfile" >"$VAULTS_FILE"
    else
      : >"$VAULTS_FILE"
    fi
    rm "$tmpfile"
}

# Ensure theme directory and minimal manifest exist in a vault
ensure_theme_scaffold() {
  local vault_path="$1"
  local theme_dir="$vault_path/.obsidian/themes/Symphony"
  mkdir -p "$theme_dir"
  if [ ! -f "$theme_dir/manifest.json" ]; then
    cat >"$theme_dir/manifest.json" <<'EOF'
{
  "name": "Symphony",
  "version": "1.0.0",
  "minAppVersion": "0.16.0",
  "description": "Automatically syncs with your current Symphony system theme colors and fonts",
  "author": "Symphony",
  "authorUrl": "https://github.com/vyrx/dotfiles"
}
EOF
  fi
  [ -f "$theme_dir/theme.css" ] || : >"$theme_dir/theme.css"
}

# Function to extract hex color from string
extract_hex_color() {
  echo "$1" | grep -oE '#[0-9a-fA-F]{6}' | head -1
}

# Function to convert RGB/RGBA to hex
rgb_to_hex() {
  local rgb_string="$1"
  if [[ $rgb_string =~ rgba?\(([0-9]+),\s*([0-9]+),\s*([0-9]+) ]]; then
    printf "#%02x%02x%02x\n" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
  fi
}

# Convert hex to RGB components
hex_to_rgb() {
  local hex="${1#\#}"
  printf "%d %d %d\n" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# Calculate perceived brightness (0-255)
calculate_brightness() {
  local hex="$1"
  read -r r g b <<<"$(hex_to_rgb "$hex")"
  # Use perceived brightness formula
  echo $(((r * 299 + g * 587 + b * 114) / 1000))
}

# Calculate approximate contrast ratio between two colors
# Returns ratio scaled by 100 (e.g., 450 = 4.5:1 ratio)
calculate_contrast_ratio() {
  local hex1="$1" hex2="$2"
  local br1=$(calculate_brightness "$hex1")  # 0-255 range
  local br2=$(calculate_brightness "$hex2")  # 0-255 range

  # Ensure br1 is the lighter color (higher brightness)
  if [ $br1 -lt $br2 ]; then
    local temp=$br1
    br1=$br2
    br2=$temp
  fi

  # Approximate contrast ratio scaled by 100
  # Add offset to avoid division by zero and approximate WCAG +0.05 behavior
  echo $(((br1 + 13) * 100 / (br2 + 13)))
}

# Check if two colors meet minimum contrast threshold
meets_contrast_threshold() {
  local ratio="$1"        # Ratio scaled by 100 (from calculate_contrast_ratio)
  local threshold="$2"    # Threshold scaled by 100 (300=3:1, 450=4.5:1, 700=7:1)
  [ $ratio -ge $threshold ]
}

# Calculate color distance (euclidean in RGB space)
color_distance() {
  local hex1="$1"
  local hex2="$2"
  read -r r1 g1 b1 <<<"$(hex_to_rgb "$hex1")"
  read -r r2 g2 b2 <<<"$(hex_to_rgb "$hex2")"
  echo $(((r1 - r2) * (r1 - r2) + (g1 - g2) * (g1 - g2) + (b1 - b2) * (b1 - b2)))
}

# Extract colors from btop theme file
extract_btop_colors() {
  local theme_dir="$1"
  local btop_file=""
  
  # Try multiple locations for btop theme
  for file in "$theme_dir/btop.theme" "$theme_dir/.config/btop/themes/current.theme"; do
    [ -f "$file" ] && btop_file="$file" && break
  done
  
  [ -z "$btop_file" ] && return 1
  
  # Extract main colors
  local main_fg=$(grep 'theme\[main_fg\]' "$btop_file" | sed 's/.*=//;s/[" ]//g;s/#//' | head -1)
  local title=$(grep 'theme\[title\]' "$btop_file" | sed 's/.*=//;s/[" ]//g;s/#//' | head -1)
  local hi_fg=$(grep 'theme\[hi_fg\]' "$btop_file" | sed 's/.*=//;s/[" ]//g;s/#//' | head -1)
  
  # Return as space-separated values
  echo "${main_fg:-ffffff} ${title:-ffffff} ${hi_fg:-ffffff}"
}

# Extract accent colors from alacritty (bright palette)
extract_alacritty_accents() {
  local theme_dir="$1"
  local alacritty_file=""
  
  for file in "$theme_dir/alacritty.toml" "$theme_dir/.config/alacritty/colors.toml"; do
    [ -f "$file" ] && alacritty_file="$file" && break
  done
  
  [ -z "$alacritty_file" ] && return 1
  
  # Extract bright colors (good for accents)
  grep -A 20 "\[colors.bright\]" "$alacritty_file" | \
    grep -E "(red|green|yellow|blue|magenta|cyan)" | \
    sed "s/.*= *[\"']\(#[0-9a-fA-F]\{6\}\)[\"'].*/\1/" | \
    tr '[:upper:]' '[:lower:]' | \
    grep -E '^#[0-9a-f]{6}$'
}

# Adjust color brightness
adjust_brightness() {
  local hex="$1"
  local amount="$2"  # Positive = lighter, negative = darker
  
  read -r r g b <<<"$(hex_to_rgb "$hex")"
  r=$((r + amount)); [ $r -lt 0 ] && r=0; [ $r -gt 255 ] && r=255
  g=$((g + amount)); [ $g -lt 0 ] && g=0; [ $g -gt 255 ] && g=255
  b=$((b + amount)); [ $b -lt 0 ] && b=0; [ $b -gt 255 ] && b=255
  
  printf "#%02x%02x%02x" "$r" "$g" "$b"
}

# Main color extraction and theme generation
extract_theme_data() {
  local theme_dir="$1"
  
  # Get primary colors from Alacritty
  local bg_color="#1a1b26"
  local fg_color="#a9b1d6"

  local alacritty_file=""
  for file in "$theme_dir/alacritty.toml" "$theme_dir/.config/alacritty/colors.toml"; do
    [ -f "$file" ] && alacritty_file="$file" && break
  done

  if [ -n "$alacritty_file" ]; then
    local extracted_bg=$(grep -A 5 "\[colors.primary\]" "$alacritty_file" | grep "^background = " | sed "s/.*= *[\"']\(#[0-9a-fA-F]\{6\}\)[\"'].*/\1/" | head -1 | tr '[:upper:]' '[:lower:]')
    local extracted_fg=$(grep -A 5 "\[colors.primary\]" "$alacritty_file" | grep "^foreground = " | sed "s/.*= *[\"']\(#[0-9a-fA-F]\{6\}\)[\"'].*/\1/" | head -1 | tr '[:upper:]' '[:lower:]')
    [ -n "$extracted_bg" ] && bg_color="$extracted_bg"
    [ -n "$extracted_fg" ] && fg_color="$extracted_fg"
  fi

  # Extract btop colors for text and accents
  read -r btop_fg btop_title btop_hi <<<"$(extract_btop_colors "$theme_dir")"
  local text_normal="#${btop_fg}"
  local accent_primary="#${btop_title}"
  local accent_secondary="#${btop_hi}"
  
  # Get accent colors from alacritty bright palette
  local -a accents
  readarray -t accents < <(extract_alacritty_accents "$theme_dir" | head -8)
  
  # Fallback if no accents found
  [ ${#accents[@]} -eq 0 ] && accents=("$accent_primary" "$accent_secondary" "$fg_color")

  # Determine if light or dark theme
  local bg_brightness=$(calculate_brightness "$bg_color")
  local is_dark=$((bg_brightness <= 127))

  # Generate background variations
  local bg_primary_alt=$(adjust_brightness "$bg_color" $((is_dark ? 8 : -8)))
  local bg_secondary=$(adjust_brightness "$bg_color" $((is_dark ? 18 : -18)))
  local bg_secondary_alt=$(adjust_brightness "$bg_color" $((is_dark ? 28 : -28)))
  local code_bg=$(adjust_brightness "$bg_color" $((is_dark ? 15 : -10)))

  # Extract text selection colors from Alacritty
  local selection_bg=""
  local selection_fg=""
  if [ -n "$alacritty_file" ]; then
    local sel_bg_line=$(grep -A 5 "\[colors.selection\]" "$alacritty_file" | grep "^background = " | head -1)
    local sel_text_line=$(grep -A 5 "\[colors.selection\]" "$alacritty_file" | grep "^text = " | head -1)

    # Parse background
    if [[ "$sel_bg_line" == *"CellForeground"* ]]; then
      selection_bg="$text_normal"
    elif [[ "$sel_bg_line" == *"CellBackground"* ]]; then
      selection_bg="$bg_color"
    else
      selection_bg=$(echo "$sel_bg_line" | sed "s/.*= *[\"']\(#[0-9a-fA-F]\{6\}\)[\"'].*/\1/" | tr '[:upper:]' '[:lower:]')
    fi

    # Parse text
    if [[ "$sel_text_line" == *"CellForeground"* ]]; then
      selection_fg="$text_normal"
    elif [[ "$sel_text_line" == *"CellBackground"* ]]; then
      selection_fg="$bg_color"
    else
      selection_fg=$(echo "$sel_text_line" | sed "s/.*= *[\"']\(#[0-9a-fA-F]\{6\}\)[\"'].*/\1/" | tr '[:upper:]' '[:lower:]')
    fi
  fi

  # Fallback selection colors
  [ -z "$selection_bg" ] && selection_bg=$(adjust_brightness "$bg_color" $((is_dark ? 30 : -30)))
  [ -z "$selection_fg" ] && selection_fg="$text_normal"

  # Extract border color from btop
  local border_color="#3d3d3d"
  local btop_file=""
  for file in "$theme_dir/btop.theme" "$theme_dir/.config/btop/themes/current.theme"; do
    [ -f "$file" ] && btop_file="$file" && break
  done
  
  if [ -n "$btop_file" ]; then
    local div_line=$(grep 'theme\[div_line\]' "$btop_file" | sed 's/.*=//;s/[" ]//g' | head -1)
    if [[ "$div_line" =~ ^#?[0-9a-fA-F]{6}$ ]]; then
      border_color="${div_line#\#}"
      border_color="#$border_color"
    fi
  fi

  # Muted text color (between fg and bg)
  read -r r1 g1 b1 <<<"$(hex_to_rgb "$bg_color")"
  read -r r2 g2 b2 <<<"$(hex_to_rgb "$text_normal")"
  local text_muted=$(printf "#%02x%02x%02x" $(((r1 + r2*2) / 3)) $(((g1 + g2*2) / 3)) $(((b1 + b2*2) / 3)))
  local text_faint=$(printf "#%02x%02x%02x" $(((r1*2 + r2) / 3)) $(((g1*2 + g2) / 3)) $(((b1*2 + b2) / 3)))

  # Extract fonts
  local monospace_font="CaskaydiaMono Nerd Font"
  local ui_font="Liberation Sans"

  if [ -f "$theme_dir/.config/alacritty/colors.toml" ]; then
    local alacritty_font=$(grep -A 5 "\[font\]" "$theme_dir/.config/alacritty/colors.toml" | grep 'family = ' | head -1 | cut -d'"' -f2)
    [ -n "$alacritty_font" ] && monospace_font="$alacritty_font"
  fi

  if [ -f "$HOME/.config/fontconfig/fonts.conf" ]; then
    local fontconfig_mono=$(xmlstarlet sel -t -v '//match[@target="pattern"][test/string="monospace"]/edit[@name="family"]/string' "$HOME/.config/fontconfig/fonts.conf" 2>/dev/null || true)
    [ -n "$fontconfig_mono" ] && monospace_font="$fontconfig_mono"

    local fontconfig_sans=$(xmlstarlet sel -t -v '//match[@target="pattern"][test/string="sans-serif"]/edit[@name="family"]/string' "$HOME/.config/fontconfig/fonts.conf" 2>/dev/null || true)
    [ -n "$fontconfig_sans" ] && ui_font="$fontconfig_sans"
  fi

  # Generate CSS
  cat <<EOF
/* Symphony Theme for Obsidian */
/* Generated: $(date '+%Y-%m-%d %H:%M') | Theme: $(get_current_theme) */

.theme-dark, .theme-light {
  /* === Core === */
  --background-primary: $bg_color;
  --background-primary-alt: $bg_primary_alt;
  --background-secondary: $bg_secondary;
  --background-secondary-alt: $bg_secondary_alt;
  
  --text-normal: $text_normal;
  --text-muted: $text_muted;
  --text-faint: $text_faint;
  
  /* === Accents === */
  --interactive-accent: $accent_primary;
  --text-accent: $accent_primary;
  --text-accent-hover: $accent_secondary;
  
  /* === Code === */
  --code-background: $code_bg;
  --code-foreground: $text_normal;
  --markup-code: ${accents[3]:-$accent_secondary};
  
  /* === Borders === */
  --border-color: $border_color;
  --background-modifier-border: $border_color;
  
  /* === Selection === */
  --text-selection: $selection_bg;
  --text-selection-fg: $selection_fg;
  
  /* === Headers === */
  --text-title-h1: ${accents[0]:-$accent_primary};
  --text-title-h2: ${accents[1]:-$accent_secondary};
  --text-title-h3: ${accents[2]:-$accent_primary};
  --text-title-h4: ${accents[3]:-$accent_secondary};
  --text-title-h5: ${accents[4]:-$accent_primary};
  --text-title-h6: ${accents[4]:-$accent_primary};
  
  /* === Links === */
  --text-link: ${accents[5]:-$accent_secondary};
  --link-color: var(--text-link);
  --link-color-hover: var(--text-accent-hover);
  --link-unresolved-color: $text_muted;
  --link-unresolved-opacity: 0.7;
  
  /* === Additional === */
  --text-mark: ${accents[6]:-$accent_primary};
  --text-highlight-bg: $accent_primary;
  --text-on-accent: $bg_color;
  --text-error: ${accents[0]:-$accent_primary};
  --text-error-hover: ${accents[0]:-$accent_primary};
  
  --blockquote-border: ${accents[2]:-$accent_primary};
  
  --interactive-normal: $code_bg;
  --interactive-hover: $accent_secondary;
  --interactive-accent-hover: $accent_secondary;
  --interactive-success: ${accents[1]:-$accent_secondary};
  
  --scrollbar-bg: $bg_color;
  --scrollbar-thumb-bg: $code_bg;
  --scrollbar-active-thumb-bg: $accent_primary;
  
  --background-modifier-form-field: $code_bg;
  --background-modifier-form-field-highlighted: $code_bg;
  --background-modifier-box-shadow: rgba(0, 0, 0, 0.3);
  --background-modifier-success: var(--interactive-success);
  --background-modifier-error: var(--text-error);
  --background-modifier-error-hover: var(--text-error);
  --background-modifier-cover: rgba(0, 0, 0, 0.8);
  
  --tag-color: ${accents[2]:-$accent_primary};
  --tag-background: $code_bg;
  
  --graph-line: $text_muted;
  --graph-node: $accent_primary;
  --graph-node-unresolved: $text_muted;
  --graph-node-focused: var(--text-link);
  --graph-node-tag: ${accents[2]:-$accent_primary};
  --graph-node-attachment: ${accents[1]:-$accent_secondary};
  
  /* === Fonts === */
  --font-interface-theme: "$ui_font";
  --font-text-theme: "$ui_font";
  --font-monospace-theme: "$monospace_font";
}

/* === Styling === */
.cm-header-1, .markdown-rendered h1 { color: var(--text-title-h1); }
.cm-header-2, .markdown-rendered h2 { color: var(--text-title-h2); }
.cm-header-3, .markdown-rendered h3 { color: var(--text-title-h3); }
.cm-header-4, .markdown-rendered h4 { color: var(--text-title-h4); }
.cm-header-5, .markdown-rendered h5 { color: var(--text-title-h5); }
.cm-header-6, .markdown-rendered h6 { color: var(--text-title-h6); }

.markdown-rendered code {
  font-family: var(--font-monospace-theme);
  background-color: var(--code-background);
  color: var(--markup-code);
  padding: 2px 4px;
  border-radius: 3px;
}

.markdown-rendered pre {
  background-color: var(--code-background);
  border: 1px solid var(--background-modifier-border);
  border-radius: 5px;
}

.markdown-rendered pre code {
  background-color: transparent;
  color: var(--code-foreground);
}

.cm-s-obsidian span.cm-keyword { color: var(--text-title-h1); }
.cm-s-obsidian span.cm-string { color: var(--text-title-h2); }
.cm-s-obsidian span.cm-number { color: var(--text-title-h3); }
.cm-s-obsidian span.cm-comment { color: var(--text-muted); }
.cm-s-obsidian span.cm-operator { color: var(--text-link); }
.cm-s-obsidian span.cm-variable { color: var(--text-normal); }
.cm-s-obsidian span.cm-def { color: var(--text-link); }

.markdown-rendered mark,
.cm-s-obsidian span.cm-highlight,
mark {
  background-color: var(--text-highlight-bg) !important;
  color: var(--code-background) !important;
}

.markdown-rendered a { color: var(--text-link); }

.markdown-rendered blockquote {
  border-left: 4px solid var(--blockquote-border);
  padding-left: 1em;
}

.status-bar {
  background-color: var(--code-background);
  border-top: 1px solid var(--background-modifier-border);
}

.workspace-leaf.mod-active .workspace-leaf-header-title {
  color: var(--interactive-accent);
}

.nav-file-title.is-active {
  background-color: var(--code-background);
  color: var(--interactive-accent);
}

::selection {
  background-color: var(--text-selection);
  color: var(--text-selection-fg);
}

.search-result-file-title { color: var(--interactive-accent); }

.search-result-file-match {
  background-color: var(--code-background);
  color: var(--text-normal);
  border-left: 3px solid var(--interactive-accent);
}

.search-result-file-matched-text { color: var(--code-background); }

.markdown-rendered table { border: 1px solid var(--background-modifier-border); }
.markdown-rendered th {
  background-color: var(--code-background);
  color: var(--text-accent);
}
.markdown-rendered td { border: 1px solid var(--background-modifier-border); }

.callout {
  border-left: 4px solid var(--interactive-accent);
  background-color: var(--code-background);
}
.callout * { color: var(--text-normal); }

.modal {
  background-color: var(--background-primary);
  border: 2px solid var(--background-modifier-border);
}

.vertical-tab-header-group-title { color: var(--interactive-accent); }

.vertical-tab-nav-item.is-active {
  background-color: var(--code-background);
  color: var(--interactive-accent);
}
EOF
}

# Option handling
if [ "${1:-}" = "--reset" ]; then
  echo "♻️  Resetting Symphony Obsidian themes and registry..."
  if [ -f "$VAULTS_FILE" ] && [ -s "$VAULTS_FILE" ]; then
    while IFS= read -r vault_path || [ -n "$vault_path" ]; do
      case "$vault_path" in ""|\#*) continue ;; esac
      vault_path="${vault_path%/}"
      vault_name=$(basename "$vault_path")
      theme_dir="$vault_path/.obsidian/themes/Symphony"
      if [ -d "$theme_dir" ]; then
        rm -rf "$theme_dir"
        echo "   ✅ $vault_name (theme removed)"
      else
        echo "   ℹ️  $vault_name (no theme present)"
      fi
    done <"$VAULTS_FILE"
  fi
  rm -f "$VAULTS_FILE"
  echo "✅ Registry removed"
  exit 0
fi

# Main update logic
CURRENT_THEME=$(get_current_theme)
THEME_DIR=$(get_theme_dir "$CURRENT_THEME")

# Check if theme directory exists
if [ ! -d "$THEME_DIR" ]; then
  echo "❌ Theme directory not found: $THEME_DIR"
  exit 1
fi

# Step 1: ensure registry exists (bootstrap if needed)
ensure_vaults_file

# Check if there are any vaults
if [ ! -s "$VAULTS_FILE" ]; then
  # No vaults found, exit silently
  exit 0
fi

while IFS= read -r vault_path || [ -n "$vault_path" ]; do
  case "$vault_path" in "" | \#*) continue ;; esac
  vault_path="${vault_path%/}"
  vault_name=$(basename "$vault_path")

  # Step 2: verify path exists; skip if invalid
  if [ ! -d "$vault_path" ] || [ ! -d "$vault_path/.obsidian" ]; then
    continue
  fi

  # Ensure theme files exist for this vault
  ensure_theme_scaffold "$vault_path"
  VAULT_THEME_DIR="$vault_path/.obsidian/themes/Symphony"

  # Step 3: update theme.css
  if [ -f "$THEME_DIR/.config/obsidian/theme.css" ]; then
    cp "$THEME_DIR/.config/obsidian/theme.css" "$VAULT_THEME_DIR/theme.css"
  else
    extract_theme_data "$THEME_DIR" >"$VAULT_THEME_DIR/theme.css"
  fi
done <"$VAULTS_FILE"
