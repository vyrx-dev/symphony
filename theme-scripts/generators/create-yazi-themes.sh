#!/bin/bash

# Generate yazi theme.toml files for all themes based on their pywal colors

THEMES_DIR="$HOME/dotfiles/themes"
MATUGEN_TEMPLATE="$HOME/.config/matugen/templates/yazi-theme.toml"

echo "Generating yazi themes for all themes..."

# Process each theme directory
for theme_dir in "$THEMES_DIR"/*/; do
  theme_name=$(basename "$theme_dir")
  
  # Skip matugen theme (handled by matugen itself)
  [ "$theme_name" = "matugen" ] && continue
  
  colors_json="$theme_dir/.cache/wal/colors.json"
  output_file="$theme_dir/.config/yazi/theme.toml"
  
  # Skip if no colors.json
  [ ! -f "$colors_json" ] && {
    echo "⚠ Skipping $theme_name (no colors.json)"
    continue
  }
  
  # Create yazi config directory
  mkdir -p "$theme_dir/.config/yazi"
  
  # Read colors from pywal json
  color0=$(jq -r '.colors.color0' "$colors_json")
  color1=$(jq -r '.colors.color1' "$colors_json")
  color2=$(jq -r '.colors.color2' "$colors_json")
  color3=$(jq -r '.colors.color3' "$colors_json")
  color4=$(jq -r '.colors.color4' "$colors_json")
  color5=$(jq -r '.colors.color5' "$colors_json")
  color6=$(jq -r '.colors.color6' "$colors_json")
  color7=$(jq -r '.colors.color7' "$colors_json")
  color8=$(jq -r '.colors.color8' "$colors_json")
  color9=$(jq -r '.colors.color9' "$colors_json")
  color10=$(jq -r '.colors.color10' "$colors_json")
  color11=$(jq -r '.colors.color11' "$colors_json")
  color12=$(jq -r '.colors.color12' "$colors_json")
  color13=$(jq -r '.colors.color13' "$colors_json")
  color14=$(jq -r '.colors.color14' "$colors_json")
  color15=$(jq -r '.colors.color15' "$colors_json")
  
  # Generate yazi theme.toml
  cat > "$output_file" << EOF
# : Manager [[[

[mgr]
cwd = { fg = "$color7" }

# Tab
tab_active = { fg = "$color0", bg = "$color4", bold = true }
tab_inactive = { fg = "$color8", bg = "$color0" }
tab_width = 1

# Find
find_keyword = { fg = "$color1", bold = true, italic = true, underline = true }
find_position = { fg = "$color1", bold = true, italic = true }

# Marker
marker_copied = { fg = "$color5", bg = "$color5" }
marker_cut = { fg = "$color13", bg = "$color13" }
marker_marked = { fg = "$color1", bg = "$color1" }
marker_selected = { fg = "$color5", bg = "$color5" }

# Count
count_copied = { fg = "$color0", bg = "$color13" }
count_cut = { fg = "$color0", bg = "$color13" }
count_selected = { fg = "$color0", bg = "$color5" }

# Border
border_symbol = " "
border_style  = { fg = "$color4" }

# : ]]]


# : Status [[[

[status]
separator_open = "🭁"
separator_close = "🭠"
separator_style = { bg = "$color0", fg = "#F4A261" }

[mode]
# Mode
normal_main = { bg = "$color4", fg = "$color0", bold = true }
normal_alt  = { bg = "$color8", fg = "$color7" }

# Select mode
select_main = { bg = "$color6", fg = "$color0", bold = true }
select_alt  = { bg = "$color8", fg = "$color7" }

# Unset mode
unset_main = { bg = "$color5", fg = "$color0", bold = true }
unset_alt  = { bg = "$color8", fg = "$color7" }

# Progress
progress_label = { bold = true }
progress_normal = { fg = "$color4", bg = "$color8" }
progress_error = { fg = "$color1", bg = "$color8" }

# Permissions
permissions_t = { fg = "$color12" }
permissions_w = { fg = "$color13" }
permissions_x = { fg = "$color9" }
permissions_r = { fg = "$color5" }
permissions_s = { fg = "$color4" }

# : ]]]


# : Select [[[

[select]
border = { fg = "$color4" }
active = { fg = "$color5", bold = true }

# : ]]]


# : Input [[[

[input]
border = { fg = "$color4" }
value = { fg = "$color7" }

# : ]]]

# : Tabs [[[

[tabs]
active = { fg = "$color4", bold = true, bg = "$color0" }
inactive = { fg = "$color6", bg = "$color0" }
sep_inner = { open = "[", close = "]" }

# : ]]]


# : Completion [[[

[completion]
border = { fg = "$color4", bg = "$color0" }

# : ]]]


# : Tasks [[[

[tasks]
border = { fg = "$color4" }
title = {}
hovered = { fg = "$color13", underline = true }

# : ]]]


# : Which [[[

[which]
cols = 3
mask = { bg = "$color8" }
cand = { fg = "$color4" }
rest = { fg = "$color0" }
desc = { fg = "$color7" }
separator = " ▶ "
separator_style = { fg = "$color7" }

# : ]]]


# : Help [[[

[help]
on = { fg = "$color7" }
run = { fg = "$color7" }
footer = { fg = "$color0", bg = "$color6" }

# : ]]]


# : Notify [[[

[notify]
title_info = { fg = "$color5" }
title_warn = { fg = "$color4" }
title_error = { fg = "$color1" }

# : ]]]


# : File-specific styles [[[

[filetype]

rules = [
    # Images
    { mime = "image/*", fg = "$color14" },

    # Media
    { mime = "{audio,video}/*", fg = "$color11" },

    # Archives
    { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "$color13" },

    # Documents
    { mime = "application/{pdf,doc,rtf}", fg = "$color10" },

    # Special files
    { name = "*", is = "orphan", bg = "$color1" },
    { name = "*", is = "exec", fg = "$color3" },

    # Fallback
    { name = "*", fg = "$color7" },
    { name = "*/", fg = "$color4" },
]

# : ]]]

EOF
  
  echo "✓ Generated $theme_name"
done

echo "Done! Yazi themes generated for all themes."
