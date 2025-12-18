#!/bin/bash
# alacritty - touch config to trigger auto-reload
pgrep -x alacritty &>/dev/null || exit 0
touch ~/.config/alacritty/alacritty.toml 2>/dev/null
