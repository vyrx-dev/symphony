#!/bin/bash
# gtk - symlink colors for gtk3 and gtk4
for ver in "gtk-3.0" "gtk-4.0"; do
    src="$CURRENT_LINK/.config/$ver/colors.css"
    [[ -f "$src" ]] || continue
    mkdir -p "$HOME/.config/$ver"
    ln -sf "$src" "$HOME/.config/$ver/colors.css"
done

# refresh gtk apps
killall nautilus 2>/dev/null
command -v nwg-look &>/dev/null && nwg-look -a &>/dev/null
exit 0
