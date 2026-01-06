#!/bin/bash

gen_rofi() {
    cat > "$dest/.config/rofi/colors.rasi" <<EOF
/* ╭─ ♪ Symphony ─╮
   │  Generated   │
   ╰──────────────╯
   Theme: Omarchy $name */

* {
    primary: $cyan;
    primary-container: $accent;
    on-primary: $bg;
    on-primary-container: $fg;
    secondary: $magenta;
    secondary-container: $bblack;
    on-secondary: $bg;
    on-secondary-container: $fg;
    surface: $bg;
    surface-dim: $bg;
    surface-bright: $bblack;
    surface-container-lowest: $bg;
    surface-container-low: $bg;
    surface-container: $bblack;
    surface-container-high: $bblack;
    surface-container-highest: $bblack;
    on-surface: $bg;
    on-surface-variant: $white;
    outline: $bblack;
    outline-variant: $bblack;
    error: $red;
    on-error: $bg;
    inverse-surface: $bg;
    inverse-on-surface: $bg;
}
EOF
}
