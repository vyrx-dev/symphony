#!/bin/bash
#
# cmd="$*"
# exec setsid uwsm-app -- alacritty -o font.size=9 --class=Omarchy --title=Omarchy -e bash -c "omarchy-show-logo; $cmd; omarchy-show-done"

cmd="$*"
exec kitty -o font.size=9 --class=april --title=april -e bash -c "$cmd; echo; read -p 'Press enter to close...'"
