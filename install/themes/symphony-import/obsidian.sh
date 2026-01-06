#!/bin/bash

gen_obsidian() {
    cat > "$dest/.config/obsidian/theme.css" <<EOF
/* ╭─ ♪ Symphony ─╮
   │  Generated   │
   ╰──────────────╯
   Theme: Omarchy $name */

.theme-dark, .theme-light {
    --background-primary: $bg;
    --background-primary-alt: $surface;
    --background-secondary: $surface;
    --background-secondary-alt: $surface;
    --background-modifier-hover: $surface;
    --background-modifier-border: $bblack;

    --text-normal: $fg;
    --text-muted: $white;
    --text-faint: $bblack;
    --text-on-accent: $bg;

    --interactive-accent: $accent;
    --interactive-accent-hover: $cyan;
    --text-accent: $accent;
    --text-accent-hover: $cyan;

    --link-color: $accent;
    --link-color-hover: $cyan;
    --link-external-color: $cyan;

    --code-background: $surface;
    --code-normal: $fg;

    --text-error: $red;
    --text-success: $green;
    --text-warning: $yellow;

    --divider-color: $bblack;
    --icon-color: $white;
    --icon-color-hover: $fg;
    --tag-color: $magenta;
    --tag-background: $surface;
}

::selection { background: ${accent}40; }
EOF
}
