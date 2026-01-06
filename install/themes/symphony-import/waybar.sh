#!/bin/bash

gen_waybar() {
    cat > "$dest/.config/waybar/colors.css" <<EOF
/* ╭─ ♪ Symphony ─╮
   │  Generated   │
   ╰──────────────╯
   Theme: Omarchy $name */

@define-color waybar_accent rgba($(hex "$fg" | sed 's/../0x& /g' | xargs printf '%d, %d, %d'), 0.18);
@define-color waybar_accent_fg @on_background;
@define-color on_background $fg;
@define-color surface_container $black;
@define-color error $red;
EOF
}
