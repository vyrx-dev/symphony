#!/bin/bash

# Script to create complete starship.toml configs for all themes
# Integrates theme-specific colors into the full starship config

THEMES_DIR="$HOME/dotfiles/themes"
DOTFILES_CONFIG="$HOME/dotfiles/.config"

# Base starship config structure (same for all themes)
create_starship_config() {
    local theme=$1
    local kitty_colors="$THEMES_DIR/$theme/.config/kitty/colors.conf"
    local output_file="$THEMES_DIR/$theme/.config/starship.toml"
    
    # Skip matugen theme - it uses template
    if [ "$theme" == "matugen" ]; then
        echo "Skipping matugen (uses template system)"
        return
    fi
    
    if [ ! -f "$kitty_colors" ]; then
        echo "Warning: $kitty_colors not found"
        return
    fi
    
    # Extract colors from kitty config
    local bg=$(grep "^background" "$kitty_colors" | awk '{print $2}')
    local fg=$(grep "^foreground" "$kitty_colors" | awk '{print $2}')
    local red=$(grep "^color1 " "$kitty_colors" | awk '{print $2}')
    local cyan=$(grep "^color6 " "$kitty_colors" | awk '{print $2}')
    local magenta=$(grep "^color5 " "$kitty_colors" | awk '{print $2}')
    local gray=$(grep "^color8 " "$kitty_colors" | awk '{print $2}')
    
    # Create complete starship.toml with embedded colors
    cat > "$output_file" << EOF
add_newline = false
command_timeout = 60
format = """\
\$os \
\$directory \
\$git_branch\$git_status\
\$line_break\
\$character\
"""

# right_format = """\
# \$time\
# """

palette = "colors"

[palettes.colors]
mustard = '#af8700'
color1 = '$cyan'        # directory path (cyan accent)
color2 = '$bg'          # unused
color3 = '$fg'          # unused
color4 = '$bg'          # unused
color5 = '$bg'          # unused
color6 = '$gray'        # vicmd symbol (muted gray)
color7 = '$bg'          # unused
color8 = '$cyan'        # os symbol, success character (primary)
color9 = '$magenta'     # git branch (secondary accent)
error = '$red'          # error character

[directory]
style = "fg:color1 bold"
read_only = " 󰌾"
read_only_style = "fg:#ea6962"
truncation_length = 0
truncate_to_repo = false
format = "[\$path](\$style)[\$read_only](\$read_only_style)"

[directory.substitutions]
'~/100xCodes/Cohort-3-WebDev' = 'Learning'
'~/Testing-repo' = 'work-project'

[character]
success_symbol = '[❯](fg:color8 bold)'
error_symbol = '[❯](fg:error bold)'
vicmd_symbol = '[❮](fg:color6 bold)'

[git_branch]
style = "fg:color9 bold"
format = '[\$symbol\$branch](\$style) '

[git_status]
ahead = '⇡\${count}'
behind = '⇣\${count}'
diverged = '⇕⇡\${ahead_count}⇣\${behind_count}'
format = '[[(\$all_status\$ahead_behind )](fg:#ea6962)](\$style)'

[os]
format = "[\$symbol](\$style)"
style = "fg:color8 bold"
disabled = false

[os.symbols]
Linux = "󰊠 "
Arch = "󰣇"
Ubuntu = "󰕈"

# [time]
# disabled = false
# format = '[[ \$time ](fg:#ea6962 )](\$style)'
# time_format = "%R"

[line_break]
disabled = true

EOF
    
    echo "✓ Created starship.toml for $theme"
}

# Process all themes
for theme in "$THEMES_DIR"/*; do
    if [ -d "$theme" ]; then
        theme_name=$(basename "$theme")
        create_starship_config "$theme_name"
    fi
done

echo ""
echo "Done! Created starship configs for all themes."
echo ""
echo "When you switch themes with stow, starship will automatically use the theme's colors."
echo "The file ~/.config/starship.toml will be a symlink to the active theme's config."
