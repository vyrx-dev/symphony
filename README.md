<div align="center">

![Banner](assets/banner.jpg)

**A minimal, productivity-focused Arch + Hyprland setup**

<a href="#install"><img src="https://img.shields.io/badge/Install-c4a7e7?style=for-the-badge&logoColor=1a1b26" alt="Install"/></a>&ensp;
<a href="#themes"><img src="https://img.shields.io/badge/Themes-f5a97f?style=for-the-badge&logoColor=1a1b26" alt="Themes"/></a>&ensp;
<a href="#keybindings"><img src="https://img.shields.io/badge/Keys-9ece6a?style=for-the-badge&logoColor=1a1b26" alt="Keys"/></a>

</div>

## Showcase

 https://github.com/user-attachments/assets/8f59ff8d-90ab-4a0c-a2d6-9346307f5de1

---

## What's in here

- **One-command theming** — `symphony switch` changes your entire desktop. terminal, bar, launcher, notifications, lock screen, even discord and spotify. all of it, one command.
- **Dynamic colors** — pick any wallpaper, matugen pulls a color palette from it and applies it everywhere.
- **11 handcrafted themes** — all dark, all cozy. no blinding light themes here.
- **Rofi menus for everything** — app launcher, emoji picker, clipboard history, wallpaper selector, power profiles.
- **Vibe / Focus mode** — full eye candy (blur, animations, gaps) or stripped-down productivity mode. `Super + Ctrl + Backspace` to toggle.
- **Music** — MPD + RMPC + Cava visualizer, all themed to match.

---

<a id="themes"></a>

## Themes

<table>
<tr>
<td align="center"><img src="assets/void.png" width="400"/><br><b>Void</b></td>
<td align="center"><img src="assets/sakura.png" width="400"/><br><b>Sakura</b></td>
</tr>
<tr>
<td align="center"><img src="assets/espresso.png" width="400"/><br><b>Espresso</b></td>
<td align="center"><img src="assets/rose-pine.png" width="400"/><br><b>Rosé Pine</b></td>
</tr>
<tr>
<td align="center"><img src="assets/gruvbox-material.png" width="400"/><br><b>Gruvbox Material</b></td>
<td align="center"><img src="assets/tokyo-night.png" width="400"/><br><b>Tokyo Night</b></td>
</tr>
<tr>
<td align="center"><img src="assets/kanagawa.png" width="400"/><br><b>Kanagawa</b></td>
<td align="center"><img src="assets/nordic.png" width="400"/><br><b>Nordic</b></td>
</tr>
<tr>
<td align="center"><img src="assets/forest.png" width="400"/><br><b>Forest</b></td>
<td align="center"><img src="assets/zen.png" width="400"/><br><b>Zen</b></td>
</tr>
</table>

<div align="center">

### Dynamic Theme

![Dynamic Theme](assets/dynamic.gif)

_Colors generated from wallpaper using Matugen_

</div>

---

<a id="install"></a>

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/vyrx-dev/symphony/main/boot.sh | bash
```

that's it. `boot.sh` handles git, gum, cloning the repo, and kicks off the installer. it also works as an updater — run it again anytime to pull the latest.

if you'd rather do it manually:

```bash
git clone https://github.com/vyrx-dev/symphony ~/symphony
cd ~/symphony && ./install.sh
```

your existing configs are backed up to `~/.config/symphony/backups/` before anything gets overwritten. themes get set up on your first login.

> [!NOTE]
> this is built for **arch linux**. it probably works on arch-based distros too, but no promises. a fresh install is the smoothest path — you'll have less conflicts to deal with.

---

## Usage

```bash
symphony switch          # pick a theme
symphony switch sakura   # switch directly
symphony switch -r       # random
symphony list            # see what's available
symphony reload          # reapply current theme
symphony update          # pull latest + redeploy
symphony restore         # roll back from a backup
symphony fresh-setup     # nuclear option — reclone + reinstall
symphony help            # everything else
```

you can also press `Super + Ctrl + Shift + Space` for the theme picker GUI.

---

<a id="keybindings"></a>

## Keybindings

i tried to make these feel natural but tweak them however you want in `config/hypr/bindings.conf`.

> 💡 press `Super + K` to see all keybindings anytime.

<details>
<summary><b>Apps</b></summary>

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + Space` | App Launcher |
| `Super + B` | Browser |
| `Super + E` | File Manager |
| `Super + M` | Spotify |
| `Super + D` | Discord |
| `Super + C` | VS Code |
| `Alt + M` | RMPC |
| `Alt + N` | Neovim |
| `Alt + Q` | Yazi |
| `Alt + /` | Btop |

</details>

<details>
<summary><b>Menus</b></summary>

| Key | Action |
|-----|--------|
| `Alt + ,` | Clipboard |
| `Alt + .` | Emoji Picker |
| `Super + Ctrl + B` | Power Profiles |
| `Super + Ctrl + Space` | Matugen Theme |
| `Super + Alt + Space` | Wallpaper Picker |
| `Super + Ctrl + Shift + Space` | Theme Switcher |

</details>

<details>
<summary><b>Windows</b></summary>

| Key | Action |
|-----|--------|
| `Super + Q` | Close |
| `Super + K` | Kill |
| `Super + Arrow` | Focus |
| `Super + Shift + Arrow` | Move |
| `Super + Ctrl + Arrow` | Resize |
| `Super + 1-9` | Workspace |
| `Super + Shift + 1-9` | Send to Workspace |
| `Super + F` | Fullscreen |
| `Super + V` | Float |
| `Super + Shift + O` | Pop (Float & Pin) |

</details>

<details>
<summary><b>System</b></summary>

| Key | Action |
|-----|--------|
| `Super + Shift + L` | Lock |
| `Super + Escape` | Power Menu |
| `Super + N` | Notifications |
| `Super + P` | Screenshot |
| `Super + R` | Record |
| `Super + Shift + R` | Record + Mic |
| `Super + Shift + P` | Color Picker |
| `Super + Backspace` | Toggle Transparency |
| `Super + Ctrl + Backspace` | Vibe / Focus Mode |
| `Ctrl + Alt + Space` | Random Wallpaper |
| `Super + Alt + ←/→` | Cycle Wallpapers |

</details>

---

## Troubleshooting

> *"with great power comes great responsibility"* — you're running a rolling release distro. things will break sometimes. that's normal. before opening an issue, try asking an AI (chatgpt, gemini, etc.) with the error message — it's usually something device-specific that they can figure out instantly.

I'm not going to build a unified settings menu or hand-hold you through editing config files — you'll just get lazy. the fastest way to get good at linux is to start using the terminal instead of digging through menus. that said, suggestions are always welcome, and if you hit a real bug please [open an issue](https://github.com/vyrx-dev/symphony/issues/new?template=bug_report.yml) so we can fix it and nobody else has to deal with the same thing.

**install broke halfway?** each script is independent. just re-run the one that failed:

```bash
./install/packages.sh
./install/deploy.sh
./install/services.sh
```

**theme looks broken?** `symphony fix` then `symphony reload`. still broken? `symphony switch sakura` to force a known-good theme.

**waybar gone?** remove `xdg-desktop-portal-gnome` if you have it installed. keep `xdg-desktop-portal-gtk`. reboot.

**sddm black screen?** `Ctrl+Alt+F3` to get a TTY, login, run `./install/post-setup.sh`.

**want to start over?** `symphony fresh-setup` backs up everything, nukes the repo, reclones from github, and reinstalls. you'll need to type "fresh" to confirm.

still stuck? scroll up — there's a link to open an issue.

---

## Credits

learned (and shamelessly copied 😁) a lot from these projects:

- [HyDE-Project/HyDE](https://github.com/HyDE-Project/HyDE)
- [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)
- [basecamp/omarchy](https://github.com/basecamp/omarchy)
- [uiriansan/SilentSDDM](https://github.com/uiriansan/SilentSDDM)
- [bjarneo/aether.nvim](https://github.com/bjarneo/aether.nvim)

wallpapers: [vyrx-dev/wallpapers](https://github.com/vyrx-dev/wallpapers)

---

<a href="https://www.star-history.com/#vyrx-dev/symphony&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=vyrx-dev/symphony&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=vyrx-dev/symphony&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=vyrx-dev/symphony&type=date&legend=top-left" />
 </picture>
</a>
<div align="center">

**[report a bug](https://github.com/vyrx-dev/symphony/issues/new?template=bug_report.yml)** · **[request a feature](https://github.com/vyrx-dev/symphony/issues/new?template=feature_request.yml)**

</div>
