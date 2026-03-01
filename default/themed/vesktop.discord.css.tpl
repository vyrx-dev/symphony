/**
 * Symphony — Generated from template
 * Based on midnight by refact0r
 * @name midnight
 * @description A dark, rounded discord theme.
 * @author refact0r
 * @version 1.6.2
 * @invite nz87hXyvcy
 * @website https://github.com/refact0r/midnight-discord
 * @source https://github.com/refact0r/midnight-discord/blob/master/midnight.theme.css
 * @authorId 508863359777505290
 * @authorLink https://www.refact0r.dev
 */

/* IMPORTANT: make sure to enable dark mode in discord settings for the theme to apply properly!!! */

@import url('https://refact0r.github.io/midnight-discord/build/midnight.css');

/* customize things here */
:root {
  --font: 'figtree';
  --corner-text: 'Symphony';

  /* status indicators */
  --online-indicator: {{ color10 }};
  --dnd-indicator: {{ color9 }};
  --idle-indicator: {{ warn }};
  --streaming-indicator: {{ color13 }};

  /* accent colors */
  --accent-1: {{ accent }};
  --accent-2: {{ accent }};
  --accent-3: {{ accent }};
  --accent-4: {{ color4 }};
  --accent-5: {{ color12 }};
  --mention: {{ color4 }};
  --mention-hover: {{ color12 }};

  /* text colors */
  --text-0: {{ background }};
  --text-1: {{ foreground }};
  --text-2: {{ foreground }};
  --text-3: {{ text }};
  --text-4: {{ subtle }};
  --text-5: {{ muted }};

  /* background and dark colors */
  --bg-1: {{ surface }};
  --bg-2: {{ overlay }};
  --bg-3: {{ surface }};
  --bg-4: {{ background }};
  --hover: {{ overlay }};
  --active: {{ color8 }};
  --message-hover: {{ surface }};

  --spacing: 12px;

  --list-item-transition: 0.2s ease;
  --unread-bar-transition: 0.2s ease;
  --moon-spin-transition: 0.4s ease;
  --icon-spin-transition: 1s ease;

  --roundness-xl: 22px;
  --roundness-l: 20px;
  --roundness-m: 16px;
  --roundness-s: 12px;
  --roundness-xs: 10px;
  --roundness-xxs: 8px;

  --discord-icon: none;
  --moon-icon: block;
  --moon-icon-url: url('https://upload.wikimedia.org/wikipedia/commons/c/c4/Font_Awesome_5_solid_moon.svg');
  --moon-icon-size: auto;

  --login-bg-filter: saturate(0.3) hue-rotate(-15deg) brightness(0.4);
  --green-to-accent-3-filter: hue-rotate(56deg) saturate(1.43);
  --blurple-to-accent-3-filter: hue-rotate(304deg) saturate(0.84) brightness(1.2);
}

/* Selected chat/friend text */
.selected_f5eb4b,
.selected_f6f816 .link_d8bfb3 {
  color: var(--text-0) !important;
  background: var(--accent-3) !important;
}

.selected_f6f816 .link_d8bfb3 * {
  color: var(--text-0) !important;
  fill: var(--text-0) !important;
}
