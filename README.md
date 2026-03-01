<div align="center">

![Banner](branding/banner.jpg)

**A minimal, productivity-focused Arch + Hyprland setup**

<a href="#install"><img src="https://img.shields.io/badge/Install-c4a7e7?style=for-the-badge&logoColor=1a1b26" alt="Install"/></a>&ensp;
<a href="#keybindings"><img src="https://img.shields.io/badge/Keys-9ece6a?style=for-the-badge&logoColor=1a1b26" alt="Keys"/></a>

</div>

> **This is my setup.** It's opinionated — the tools I chose because I like them. You might too, or you might not. Either way, it works.
>
> Built for **NVIDIA GPUs**. AMD/Intel? A few lines to change — ask an AI, it'll sort you out.
>
> Tested on Arch and CachyOS (no desktop environment).
>
> **Note:** I purposely avoided quickshell. It's convenient but eats RAM and slows things down. Everything here is TUI-based — snappy, lightweight, and still packed with features. Keep reading.

## Showcase

https://github.com/user-attachments/assets/8f59ff8d-90ab-4a0c-a2d6-9346307f5de1

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/vyrx-dev/symphony/symphony-3.0/boot.sh | bash
```

`boot.sh` installs git and gum if needed, clones the repo, and runs the installer. Run it again anytime to update.

Manual install:

```bash
git clone -b symphony-3.0 https://github.com/vyrx-dev/symphony ~/symphony
cd ~/symphony && ./install.sh
```

Existing configs are backed up to `~/.config/symphony/backups/` before overwriting.

---

## Usage

```bash
symphony switch          # pick a theme
symphony switch sakura   # switch directly
symphony switch -r       # random theme
symphony list            # show available themes
symphony reload          # reapply current theme
symphony update          # pull latest + redeploy
symphony restore         # roll back from backup
symphony fresh-setup     # reclone + reinstall
symphony help            # show all commands
```

Theme picker GUI: `Super + Ctrl + Shift + Space`

---

## Keybindings

Tweak them in `config/hypr/bindings.conf`.

> `Super + K` shows all keybindings.

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

Rolling release = things break. Before opening an issue, paste the error into an AI — usually device-specific.

**Install failed halfway?** Re-run the failed script:

```bash
./install/packages.sh
./install/deploy.sh
./install/services.sh
```

**Theme broken?** `symphony fix` then `symphony reload`. Still broken? `symphony switch sakura`.

**Waybar missing?** Remove `xdg-desktop-portal-gnome` (keep `xdg-desktop-portal-gtk`), reboot.

**SDDM black screen?** `Ctrl+Alt+F3`, login, run `./install/post-setup.sh`.

**Want to start over?** `symphony fresh-setup` — backs up, nukes, reclones, reinstalls. Type "fresh" to confirm.

Still stuck? [Open an issue](https://github.com/vyrx-dev/symphony/issues/new?template=bug_report.yml).

---

## Credits

Learned (and borrowed) from:

- [HyDE-Project/HyDE](https://github.com/HyDE-Project/HyDE)
- [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)
- [basecamp/omarchy](https://github.com/basecamp/omarchy)
- [uiriansan/SilentSDDM](https://github.com/uiriansan/SilentSDDM)
- [bjarneo/aether.nvim](https://github.com/bjarneo/aether.nvim)

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
