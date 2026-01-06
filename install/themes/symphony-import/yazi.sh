#!/bin/bash

gen_yazi() {
    cat > "$dest/.config/yazi/theme.toml" <<EOF
# ╭─ ♪ Symphony ─╮
# │  Generated   │
# ╰──────────────╯
# Theme: Omarchy $name

[mgr]
cwd = { fg = "$fg" }

find_keyword = { fg = "$cyan", bold = true, italic = true, underline = true }
find_position = { fg = "$cyan", bold = true, italic = true }

marker_copied = { fg = "$cyan", bg = "$cyan" }
marker_cut = { fg = "$red", bg = "$red" }
marker_marked = { fg = "$yellow", bg = "$yellow" }
marker_selected = { fg = "$accent", bg = "$accent" }

count_copied = { fg = "$bg", bg = "$cyan" }
count_cut = { fg = "$bg", bg = "$red" }
count_selected = { fg = "$bg", bg = "$accent" }

border_symbol = " "
border_style = { fg = "$accent" }

[status]
sep_left = { open = "", close = "🭠" }
sep_right = { open = "🭁", close = "" }

perm_type = { fg = "$accent" }
perm_read = { fg = "$cyan" }
perm_write = { fg = "$yellow" }
perm_exec = { fg = "$red" }
perm_sep = { fg = "$magenta" }

progress_label = { bold = true }
progress_normal = { fg = "$accent", bg = "$surface" }
progress_error = { fg = "$red", bg = "$surface" }

[mode]
normal_main = { bg = "$accent", fg = "$bg", bold = true }
normal_alt = { bg = "$surface", fg = "$fg" }

select_main = { bg = "$magenta", fg = "$bg", bold = true }
select_alt = { bg = "$surface", fg = "$fg" }

unset_main = { bg = "$cyan", fg = "$bg", bold = true }
unset_alt = { bg = "$surface", fg = "$fg" }

[select]
border = { fg = "$accent" }
active = { fg = "$cyan", bold = true }

[input]
border = { fg = "$accent" }
value = { fg = "$fg" }

[tabs]
active = { fg = "$accent", bold = true, bg = "$bg" }
inactive = { fg = "$bblack", bg = "$bg" }
sep_inner = { open = "[", close = "]" }

[cmp]
border = { fg = "$accent", bg = "$bg" }
EOF
}
