#!/bin/bash
# kitty, alacritty, ghostty

gen_terminals() {
    cat > "$dest/.config/kitty/colors.conf" <<EOF
# ╭─ ♪ Symphony ─╮
# │  Generated   │
# ╰──────────────╯
# Theme: Omarchy $name

background $bg
foreground $fg
selection_background $cyan
selection_foreground $bg
cursor $fg
cursor_text_color $bg
active_tab_background $accent
active_tab_foreground $bg
inactive_tab_background $bblack
inactive_tab_foreground $white
active_border_color $accent
inactive_border_color $bblack
color0 $black
color1 $red
color2 $green
color3 $yellow
color4 $blue
color5 $magenta
color6 $cyan
color7 $white
color8 $bblack
color9 $bred
color10 $bgreen
color11 $byellow
color12 $bblue
color13 $bmagenta
color14 $bcyan
color15 $bwhite
EOF

    cat > "$dest/.config/alacritty/colors.toml" <<EOF
# ╭─ ♪ Symphony ─╮
# │  Generated   │
# ╰──────────────╯
# Theme: Omarchy $name

[colors.primary]
background = '$bg'
foreground = '$fg'

[colors.normal]
black = '$black'
red = '$red'
green = '$green'
yellow = '$yellow'
blue = '$blue'
magenta = '$magenta'
cyan = '$cyan'
white = '$white'

[colors.bright]
black = '$bblack'
red = '$bred'
green = '$bgreen'
yellow = '$byellow'
blue = '$bblue'
magenta = '$bmagenta'
cyan = '$bcyan'
white = '$bwhite'
EOF

    cat > "$dest/.config/ghostty/theme" <<EOF
# ╭─ ♪ Symphony ─╮
# │  Generated   │
# ╰──────────────╯
# Theme: Omarchy $name

background = $bg
foreground = $fg
palette = 0=$black
palette = 1=$red
palette = 2=$green
palette = 3=$yellow
palette = 4=$blue
palette = 5=$magenta
palette = 6=$cyan
palette = 7=$white
palette = 8=$bblack
palette = 9=$bred
palette = 10=$bgreen
palette = 11=$byellow
palette = 12=$bblue
palette = 13=$bmagenta
palette = 14=$bcyan
palette = 15=$bwhite
EOF
}
