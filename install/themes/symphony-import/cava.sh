#!/bin/bash

gen_cava() {
    cat > "$dest/.config/cava/config" <<EOF
# ╭─ ♪ Symphony ─╮
# │  Generated   │
# ╰──────────────╯
# Theme: Omarchy $name

[color]
background = 'default'
gradient = 1
gradient_count = 4
gradient_color_1 = '$accent'
gradient_color_2 = '$magenta'
gradient_color_3 = '$cyan'
gradient_color_4 = '$green'
EOF
}
