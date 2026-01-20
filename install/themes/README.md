<div align="center">

![Banner](../../assets/banner.jpg)

</div>

I spend a lot of time with music — jazz, instrumentals, film scores. La La Land and Your Lie in April are some of my favorites. Symphony is named after that love, and you'll see the music touch throughout the setup.

## Installation

```bash
git clone https://github.com/vyrx-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles/install/themes
./install.sh
```

Uninstall:
```bash
./uninstall.sh
```

## Themes

<div align="center">

<table>
<tr>
<td align="center"><img src="../../assets/void.png" width="400"/><br><b>Void</b></td>
<td align="center"><img src="../../assets/sakura.png" width="400"/><br><b>Sakura</b></td>
</tr>
<tr>
<td align="center"><img src="../../assets/espresso.png" width="400"/><br><b>Espresso</b></td>
<td align="center"><img src="../../assets/rose-pine.png" width="400"/><br><b>Rosé Pine</b></td>
</tr>
<tr>
<td align="center"><img src="../../assets/gruvbox-material.png" width="400"/><br><b>Gruvbox Material</b></td>
<td align="center"><img src="../../assets/tokyo-night.png" width="400"/><br><b>Tokyo Night</b></td>
</tr>
<tr>
<td align="center"><img src="../../assets/kanagawa.png" width="400"/><br><b>Kanagawa</b></td>
<td align="center"><img src="../../assets/nordic.png" width="400"/><br><b>Nordic</b></td>
</tr>
<tr>
<td align="center"><img src="../../assets/forest.png" width="400"/><br><b>Forest</b></td>
<td align="center"><img src="../../assets/zen.png" width="400"/><br><b>Zen</b></td>
</tr>
</table>

</div>

<div align="center">

### Dynamic Theme

<img src="../../assets/dynamic.gif" width="800"/>

*Colors generated from wallpaper using Matugen*

</div>

Wallpapers: [vyrx-dev/wallpapers](https://github.com/vyrx-dev/wallpapers)

## Usage

```bash
symphony switch          # pick a theme
symphony switch zen      # switch directly
symphony switch --random # switch to a random theme
symphony list            # see all themes
symphony reload          # re-apply current
symphony fix             # fix broken symlinks
```

## Keybindings

| Shortcut | Action |
|----------|--------|
| `Super + Ctrl + Shift + Space` | Theme switcher |
| `Super + Ctrl + Space` | Matugen (colors from wallpaper) |
| `Super + Alt + Space` | Wallpaper picker |
| `Super + Alt + Left/Right` | Cycle wallpapers |
| `Super + Backspace` | Toggle terminal transparency |
| `Super + Ctrl + Backspace` | Toggle focus/vibe mode |

## How it works

Symphony updates `~/.config/symphony/current` and runs hooks to reload apps. No files are overwritten.

## Hooks (what it covers)

- Terminals: kitty, ghostty, alacritty
- UI: Hyprland, Waybar, GTK3/4, Rofi
- Utilities: btop, cava
- Apps: yazi, rmpc, vesktop, obsidian
- Extras: pywalfox

## Customization

### Themed Rofi

Rofi has a transparent glass/blur look by default - works well with any wallpaper. If you want it to match your theme colors instead:

1. Open `~/.config/rofi/config.rasi`
2. Uncomment `@import "colors.rasi"`
3. Replace hardcoded color values with variables from `colors.rasi`

Each theme has its own `colors.rasi` in `themes/<name>/.config/rofi/`

### Themed Neovim

Each theme includes a `theme.lua` in `themes/<name>/.config/nvim/`. To use it, copy or symlink to your nvim config:

```bash
ln -sf ~/.config/symphony/current/.config/nvim/theme.lua ~/.config/nvim/lua/plugins/theme.lua
```

## Adding your own theme

Copy an existing theme:
```bash
cp -r themes/zen themes/my-theme
```
Edit configs in `themes/my-theme/.config/` and add wallpapers to `themes/my-theme/backgrounds/`.

## Dependencies

- Required: `stow`, `hyprctl`, `swww`
- Terminal (one of): `kitty`, `ghostty`, `alacritty`
- Optional: `waybar`, `rofi`, `gum`, `tte`, `matugen`

## Troubleshooting

```bash
symphony reload    # colors not updating
symphony fix       # symlinks broken
```

---

Thanks / Inspirations:
- [basecamp/omarchy](https://github.com/basecamp/omarchy)
- [HyDE-Project/HyDE](https://github.com/HyDE-Project/HyDE)
- [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)
- [mylinuxforwork/dotfiles](https://github.com/mylinuxforwork/dotfiles)
- [bjarneo/omarchy-sakura-theme](https://github.com/bjarneo/omarchy-sakura-theme)
- [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [EliverLara/Nordic](https://github.com/EliverLara/Nordic)
- [rose-pine/rose-pine-theme](https://github.com/rose-pine/rose-pine-theme)
- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [InioX/matugen](https://github.com/InioX/matugen)

Have an idea or found a bug?
- Report a bug: [new bug](https://github.com/vyrx-dev/dotfiles/issues/new?template=bug_report.yml)
- Request a feature: [new feature](https://github.com/vyrx-dev/dotfiles/issues/new?template=feature_request.yml)
