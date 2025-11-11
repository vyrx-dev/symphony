#!/bin/bash

browser=$(xdg-settings get default-web-browser)

case $browser in
brave-browser* | google-chrome* | microsoft-edge* | opera* | vivaldi* | helium-browser*) ;;
*) browser="chromium.desktop" ;;
esac

exec setsid uwsm-app -- $(sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$browser 2>/dev/null | head -1) --app="$1" "${@:2}"
