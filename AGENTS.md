# Agent Guidelines for Hyprland Dotfiles

## Project Overview
Bash scripts for Hyprland window manager automation (wallpaper management, theming, rofi menus, tmux sessions, system utilities).

## Build/Test/Lint
- **No build system**: Scripts are executed directly
- **Test individual script**: `bash -n <script>.sh` (syntax check) or execute directly
- **Dependencies**: hyprctl, jq, pactl, notify-send, swww, rofi, nmcli, mpc, fd, fzf, tmux

## Code Style

### Shell Scripts
- **Shebang**: Use `#!/bin/bash` or `#!/usr/bin/env bash` (first line, no exceptions)
- **Variables**: UPPERCASE for constants/globals (e.g., `WALLPAPER_DIR`), lowercase for local vars (e.g., `selected_name`)
- **Quoting**: Always quote variables: `"$VARIABLE"`, array expansions: `"${array[@]}"`, paths with spaces
- **Arrays**: Use `mapfile -t array < <(command)` or `mapfile -d '' array < <(command -print0)` for building arrays from command output
- **Error handling**: Exit with `exit 1` on errors, use `notify-send` for user-facing errors, validate inputs before processing
- **Conditionals**: Use `[[ ]]` for tests, not `[ ]`; place `then`/`do` on same line as `if`/`while`/`for`
- **JSON parsing**: Always use `jq` for JSON manipulation (e.g., `jq -r '.field'`), pipe hyprctl output through jq
- **Process management**: Use `pgrep`, `pkill` with `-x` or `-f` flags; check existence with `command -v`
- **Comments**: Brief inline comments explaining intent (e.g., `# Close all open windows`), include dependency notes where relevant

### Formatting
- Indent with 2 spaces, no tabs
- Multi-line pipes should be indented for readability
- Use `||` and `&&` for conditional execution (e.g., `swww query &>/dev/null || swww-daemon`)

### Config Files
- **Waybar/JSON**: Use JSONC format with `//` comments allowed
- **CSS**: Standard CSS3, supports color variables from `colors.css`
