#!/bin/bash

gen_btop() {
    cat > "$dest/.config/btop/themes/current.theme" <<EOF
## ╭─ ♪ Symphony ─╮
## │  Generated   │
## ╰──────────────╯
## Theme: Omarchy $name

theme[main_bg]="$bg"
theme[main_fg]="$fg"
theme[title]="$fg"
theme[hi_fg]="$cyan"
theme[selected_bg]="$bblack"
theme[selected_fg]="$fg"
theme[inactive_fg]="$bblack"
theme[proc_misc]="$cyan"
theme[cpu_box]="$bblack"
theme[mem_box]="$bblack"
theme[net_box]="$bblack"
theme[proc_box]="$bblack"
theme[div_line]="$bblack"
theme[temp_start]="$green"
theme[temp_mid]="$yellow"
theme[temp_end]="$red"
theme[cpu_start]="$green"
theme[cpu_mid]="$yellow"
theme[cpu_end]="$red"
theme[free_start]="$green"
theme[free_mid]="$yellow"
theme[free_end]="$red"
theme[cached_start]="$green"
theme[cached_mid]="$yellow"
theme[cached_end]="$red"
theme[available_start]="$green"
theme[available_mid]="$yellow"
theme[available_end]="$red"
theme[used_start]="$green"
theme[used_mid]="$yellow"
theme[used_end]="$red"
theme[download_start]="$green"
theme[download_mid]="$yellow"
theme[download_end]="$red"
theme[upload_start]="$green"
theme[upload_mid]="$yellow"
theme[upload_end]="$red"
EOF
}
