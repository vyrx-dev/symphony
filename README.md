<div align="center">
  
<img src="assets/banner.jpg" alt="Symphony" width="100%" height="300" style="object-fit: cover; object-position: center;">

>*My daily driver setup — simple, calm and easy to work with.
Minimal by default, but still has a bit of character.
Animations, gaps, and extras can be toggled on/off, so you can choose between clean or pretty.*

**Inspired by the way music balances silence and sound 🎼**

</div>

## Showcase

<div align="center">

![Desktop Showcase](assets/Desktop.png)
  
<https://github.com/user-attachments/assets/75f0924e-fc4d-40ef-89c8-8034a750f886>

<https://github.com/user-attachments/assets/f5f809f3-c88d-4c13-8684-80d48e206f5e>

<https://github.com/user-attachments/assets/d733f891-dcc3-4d10-8efd-3e2f46fe9cdf>

</div>

## Features

- **Matugen theming** — Automatic color scheme generation from wallpapers
- **Modular configuration** — Clean, organized, and easy to customize
- **Complete development environment** — Hyprland, Neovim, Tmux, and essential tools
- **Comprehensive tooling** — Waybar, Rofi, Swaync, Wlogout, Hyprlock
- **GNU Stow** — Efficient dotfile management
- **Dual-mode system** — [Vibe mode](#dual-mode-system) for aesthetics, [Focus mode](#dual-mode-system) for distraction-free work
- **[Wallpaper collection](https://github.com/vyrx-dev/wallpapers)** — My favourite Wallpapers Collection

---

## Dual Mode System

This setup adapts to your workflow with two distinct modes:

<details>
<summary><b>Vibe Mode</b></summary>

Visual-first experience with animations, borders, and transparency for a polished aesthetic.

</details>

<details>
<summary><b>Focus Mode</b></summary>

Minimal, distraction-free environment:

- Animations disabled completely
- Borders reduced to minimal thickness
- Transparency removed by default
- Toggle transparency on demand: `Super + Backspace`

Perfect for deep work sessions where performance and focus take priority over visuals.

</details>

**Switch modes:** `Super + Ctrl + Backspace`

---

## Components

<details>
<summary><b>Rofi Menus</b></summary>

![Rofi](assets/rofi.png)

### Emoji Picker

![Emoji Picker](assets/emoji.png)

### Clipboard Manager

![Clipboard](assets/clipboard.png)

### Wallpaper Selector

![Wallpaper Selector](assets/wallpaper-selector.png)

### Power Profile Manager

![Power Profile](assets/powerprofile.png)

</details>

<details>
<summary><b>Notification Center (Swaync)</b></summary>

![Swaync 1](assets/swaync-1.png)
![Swaync 2](assets/swaync-2.png)
![Swaync 3](assets/swaync-3.png)

</details>

<details>
<summary><b>Neovim & Tmux</b></summary>

![Neovim Dashboard](assets/neovim_dashboard.png)
![Neovim 1](assets/Neovim-1.png)
![Neovim 2](assets/Neovim-2.png)

</details>

<details>
<summary><b>Music (RMPC)</b></summary>

![RMPC](assets/rmpc.png)

</details>

<details>
<summary><b>Wlogout</b></summary>

![Wlogout](assets/wlogout.png)

</details>

<details>
<summary><b>Hyprlock</b></summary>

![Hyprlock](assets/hyprlock.png)

</details>

---

## Installation

### Before Installation

> **⚠️ Important:** GNU Stow will not work if configuration directories or files already exist.

Backup and remove existing configurations:

```bash
# Backup existing configs (recommended)
mv ~/.config/hypr ~/.config/hypr.bak
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.config/tmux ~/.config/tmux.bak
mv ~/.config/waybar ~/.config/waybar.bak
mv ~/.config/rofi ~/.config/rofi.bak
mv ~/.config/kitty ~/.config/kitty.bak
mv ~/.config/fish ~/.config/fish.bak
mv ~/.config/swaync ~/.config/swaync.bak

# Or remove directly (use with caution)
rm -rf ~/.config/hypr ~/.config/nvim ~/.config/tmux
```

### Prerequisites

```bash
# Core dependencies
sudo pacman -S stow git base-devel

# Hyprland & Wayland
sudo pacman -S hyprland xdg-desktop-portal-hyprland

# System utilities
sudo pacman -S waybar rofi swaync swww hypridle hyprlock wlogout
sudo pacman -S polkit-gnome cliphist wl-clipboard

# Terminal & Shell
sudo pacman -S kitty alacritty fish starship tmux

# Development
sudo pacman -S neovim lazygit btop yazi

# Audio & Media
sudo pacman -S pipewire wireplumber pavucontrol mpd mpc ncmpcpp

# Theming
sudo pacman -S matugen pywalfox

# Additional tools
sudo pacman -S fastfetch jq fd ripgrep fzf swayosd
```

### Clone & Install

```bash
# Clone the repository
git clone https://github.com/vyrx-dev/dotfiles.git ~/dotfiles

# Navigate to the directory
cd ~/dotfiles

# Create symlinks using GNU Stow
stow .
```

> **💡 Tip:** Grab wallpapers from [here](https://github.com/vyrx-dev/wallpapers) for automatic theming.

### Post-Installation

After running `stow .`, all configuration files will be symlinked to their appropriate locations in `~/.config/`.

If you want to uninstall:

```bash
cd ~/dotfiles
stow -D .
```

---

## Tools Included

| Tool | Description |
|------|-------------|
| **[Hyprland](https://github.com/hyprwm/Hyprland)** | Dynamic tiling Wayland compositor |
| **[Waybar](https://github.com/Alexays/Waybar)** | Highly customizable status bar |
| **[Rofi](https://github.com/lbonn/rofi)** | Application launcher and menu system |
| **[Swaync](https://github.com/ErikReider/SwayNotificationCenter)** | Notification daemon with control center |
| **[Kitty](https://github.com/kovidgoyal/kitty)** | GPU-accelerated terminal emulator |
| **[Alacritty](https://github.com/alacritty/alacritty)** | Fast, cross-platform terminal emulator |
| **[Neovim](https://github.com/neovim/neovim)** | Hyperextensible Vim-based text editor |
| **[Tmux](https://github.com/tmux/tmux)** | Terminal multiplexer |
| **[Fish](https://github.com/fish-shell/fish-shell)** | Smart and user-friendly shell |
| **[Starship](https://github.com/starship/starship)** | Minimal, fast, and customizable prompt |
| **[Lazygit](https://github.com/jesseduffield/lazygit)** | Simple terminal UI for git commands |
| **[Matugen](https://github.com/InioX/matugen)** | Material Design color scheme generator |
| **[RMPC](https://github.com/mierak/rmpc)** | Rusty Music Player Client for MPD |

---

## Keyboard Shortcuts

### Applications

| Keybind | Action |
|---------|--------|
| `Super + Return` | Terminal (Kitty) |
| `Super + B` | Browser |
| `Super + E` | File Manager (Nautilus) |
| `Super + M` | Music (Spotify) |
| `Super + D` | Discord |
| `Super + O` | Obsidian |
| `Super + C` | VS Code |

### Rofi Menus

| Keybind | Action |
|---------|--------|
| `Super + Space` | Application Launcher |
| `Alt + ,` | Clipboard Manager |
| `Alt + .` | Emoji Picker |
| `Super + Ctrl + B` | Power Profiles |
| `Super + Ctrl + Space` | Theme Selector (Matugen) |
| `Super + Alt + Space` | Wallpaper Picker |

### Window Management

| Keybind | Action |
|---------|--------|
| `Super + Q` | Close Window |
| `Super + K` | Kill Application |
| `Super + Shift + O` | Pop Window (Float & Pin) |

### System

| Keybind | Action |
|---------|--------|
| `Super + L` | Lock Screen (Hyprlock) |
| `Super + Escape` | Wlogout Menu |
| `Super + N` | Notification Center |
| `Alt + /` | System Monitor (btop) |
| `Super + Backspace` | Toggle Terminal Transparency |
| `Super + Ctrl + Backspace` | Toggle Focus/Vibe Mode |

### Screenshots & Recording

| Keybind | Action |
|---------|--------|
| `Super + P` | Screenshot Region |
| `Super + R` | Screen Record (System Audio) |
| `Super + Alt + R` | Screen Record (System + Mic) |
| `Super + Shift + P` | Color Picker |

### Tmux Sessions

| Keybind | Action |
|---------|--------|
| `Super + Shift + Return` | Attach Tmux Session |
| `Super + Alt + Return` | New Tmux Session |

*For complete keybindings, see [.config/hypr/bindings.conf](.config/hypr/bindings.conf)*

---

## Configuration Structure

```
.config/
├── hypr/           # Hyprland configuration
├── waybar/         # Status bar
├── rofi/           # Launchers and menus
├── swaync/         # Notification center
├── kitty/          # Terminal (Kitty)
├── alacritty/      # Terminal (Alacritty)
├── nvim/           # Neovim configuration
├── tmux/           # Tmux configuration
├── fish/           # Fish shell
├── matugen/        # Theme generator
└── starship.toml   # Shell prompt
```

---

## TODO

- [ ] **Full installation script** — Automated setup for dependencies and configuration
- [ ] **Matugen integration for RMPC** — Dynamic theming for music player
- [ ] **Matugen integration for Rofi** — Dynamic theming (keeping current theme as fallback)
- [ ] **Neovim cleanup** — Remove unused plugins and optimize configuration
- [ ] **Media conversion scripts** — Video and image conversion utilities
- [ ] **Fish shell abbreviations** — Convert aliases to proper abbreviations
- [ ] **Theme Switcher** — Implement dynamic theme switching interface
- [ ] **Spicetify Pywal integration** — Add Spotify theming support

---

<div align="center">

**If you found this useful, consider giving it a ⭐**

Made with ❤️ for the Linux community

</div>
