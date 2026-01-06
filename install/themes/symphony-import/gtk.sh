#!/bin/bash

gen_gtk() {
    local gtk_css="$dest/.config/gtk-3.0/colors.css"
    cat > "$gtk_css" <<EOF
/* ╭─ ♪ Symphony ─╮
   │  Generated   │
   ╰──────────────╯
   Theme: Omarchy $name */

@define-color background $bg;
@define-color foreground $fg;
@define-color black $black;
@define-color red $red;
@define-color green $green;
@define-color yellow $yellow;
@define-color blue $blue;
@define-color magenta $magenta;
@define-color cyan $cyan;
@define-color white $white;
@define-color bright_black $bblack;
@define-color bright_white $bwhite;
@define-color accent_bg_color $accent;
@define-color accent_fg_color $bg;
@define-color accent_color $accent;
@define-color window_bg_color $bg;
@define-color window_fg_color $fg;
@define-color view_bg_color $bg;
@define-color view_fg_color $fg;
@define-color sidebar_bg_color $surface;
@define-color sidebar_fg_color $fg;
@define-color sidebar_backdrop_color $bg;
@define-color sidebar_shade_color $bg;
@define-color headerbar_bg_color $surface;
@define-color headerbar_fg_color $fg;
@define-color headerbar_backdrop_color $bg;
@define-color headerbar_shade_color $bg;
@define-color card_bg_color $surface;
@define-color card_fg_color $fg;
@define-color popover_bg_color $surface;
@define-color popover_fg_color $fg;
@define-color dialog_bg_color $surface;
@define-color dialog_fg_color $fg;
@define-color destructive_bg_color $red;
@define-color destructive_fg_color $bg;
@define-color destructive_color $red;
@define-color success_bg_color $green;
@define-color success_fg_color $bg;
@define-color success_color $green;
@define-color warning_bg_color $yellow;
@define-color warning_fg_color $bg;
@define-color warning_color $yellow;
@define-color error_bg_color $red;
@define-color error_fg_color $bg;
@define-color error_color $red;
@define-color borders alpha(@foreground, 0.1);
@define-color theme_fg_color @foreground;
@define-color theme_text_color @foreground;
@define-color theme_bg_color @background;
@define-color theme_base_color @black;
@define-color theme_selected_bg_color @accent_bg_color;
@define-color theme_selected_fg_color @accent_fg_color;
@define-color insensitive_bg_color @background;
@define-color insensitive_fg_color @bright_black;
@define-color insensitive_base_color @black;
messagedialog { background-color: @dialog_bg_color; }
messagedialog label { color: @dialog_fg_color; }
banner revealer widget { background: @bright_black; padding: 5px; color: @foreground; }
alertdialog.background { background-color: @dialog_bg_color; color: @dialog_fg_color; }
alertdialog box { background-color: @dialog_bg_color; }
alertdialog label { color: @dialog_fg_color; }
toast { background-color: @card_bg_color; color: @foreground; }
EOF
    cp "$gtk_css" "$dest/.config/gtk-4.0/colors.css"
}
