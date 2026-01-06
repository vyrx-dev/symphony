#!/bin/bash

gen_vesktop() {
    local accent_hover=$(darken "$accent" 50)
    local accent_click=$(darken "$accent" 25)
    cat > "$dest/.config/vesktop/themes/symphony-discord.css" <<EOF
/* ╭─ ♪ Symphony ─╮
   │  Generated   │
   ╰──────────────╯

   Theme: Omarchy $name
   Based on midnight by refact0r
   https://github.com/refact0r/midnight-discord */

@import url('https://refact0r.github.io/midnight-discord/build/midnight.css');

:root {
    --font: 'figtree';
    --corner-text: 'Symphony';

    /* status indicators */
    --online-indicator: $green;
    --dnd-indicator: $red;
    --idle-indicator: $yellow;
    --streaming-indicator: $magenta;

    /* accent colors */
    --accent-1: $accent;
    --accent-2: $accent;
    --accent-3: $accent;
    --accent-4: $accent_hover;
    --accent-5: $accent_click;
    --mention: $accent_hover;
    --mention-hover: $accent_click;

    /* text colors */
    --text-0: $bg;
    --text-1: $fg;
    --text-2: $fg;
    --text-3: $white;
    --text-4: $bblack;
    --text-5: $bblack;

    /* background colors */
    --bg-1: $black;
    --bg-2: $surface;
    --bg-3: $surface;
    --bg-4: $bg;
    --hover: $surface;
    --active: $accent;
    --message-hover: $surface;

    /* corner roundness */
    --roundness-xl: 22px;
    --roundness-l: 20px;
    --roundness-m: 16px;
    --roundness-s: 12px;
    --roundness-xs: 10px;
    --roundness-xxs: 8px;

    --discord-icon: none;
    --moon-icon: block;
}

.selected_f5eb4b, .selected_f6f816 .link_d8bfb3 { color: var(--text-0) !important; background: var(--accent-3) !important; }
.selected_f6f816 .link_d8bfb3 * { color: var(--text-0) !important; fill: var(--text-0) !important; }
EOF
}
