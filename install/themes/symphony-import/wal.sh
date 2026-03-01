#!/bin/bash

gen_wal() {
    mkdir -p "$dest/.cache/wal"
    cat > "$dest/.cache/wal/colors.json" <<EOF
{
    "_comment": "Symphony Generated - Omarchy $name",
    "wallpaper": "$dest/wallpaper",
    "alpha": "100",
    "special": {
        "background": "$bg",
        "foreground": "$fg",
        "cursor": "$cyan"
    },
    "colors": {
        "color0": "$black",
        "color1": "$red",
        "color2": "$green",
        "color3": "$yellow",
        "color4": "$blue",
        "color5": "$magenta",
        "color6": "$cyan",
        "color7": "$white",
        "color8": "$bblack",
        "color9": "$bred",
        "color10": "$bgreen",
        "color11": "$byellow",
        "color12": "$bblue",
        "color13": "$bmagenta",
        "color14": "$bcyan",
        "color15": "$bwhite"
    }
}
EOF

    cat > "$dest/.cache/wal/colors" <<EOF
$black
$red
$green
$yellow
$blue
$magenta
$cyan
$white
$bblack
$bred
$bgreen
$byellow
$bblue
$bmagenta
$bcyan
$bwhite
EOF
}
