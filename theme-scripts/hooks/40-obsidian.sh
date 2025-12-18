#!/bin/bash
# obsidian - symlink theme css

# find obsidian vault
for dir in "$HOME/Documents/Notes" "$HOME/Documents/Obsidian" "$HOME/obsidian" "$HOME/Obsidian"; do
    [[ -d "$dir/.obsidian" ]] && vault="$dir" && break
done
[[ -z "$vault" ]] && exit 0

src="$CURRENT_LINK/.config/obsidian/theme.css"
[[ -f "$src" ]] || exit 0

# create symphony theme dir and symlink
dest="$vault/.obsidian/themes/Symphony"
mkdir -p "$dest"
ln -sf "$src" "$dest/theme.css"

# create manifest if missing
[[ -f "$dest/manifest.json" ]] || echo '{"name":"Symphony","version":"1.0.0","minAppVersion":"0.16.0"}' > "$dest/manifest.json"
exit 0
