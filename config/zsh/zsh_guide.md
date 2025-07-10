# **🐚 Zsh Config Guide (Arch Linux + Hyprland)**

Hey there! This is my personal Zsh setup, tailored for a smooth and fun terminal experience on Arch Linux with Hyprland. It’s perfect for Git workflows, Arch tweaks, and a bit of personal flair—grab it, tweak it, and make it yours. Let’s dive in!

---

## **⚙️ What’s in This Setup**

- 🧠 **Handy aliases** for Git, npm, Arch, and more.
- 🎨 **Powerlevel10k prompt** for a polished look.
- 🧩 **Plugins** like autosuggestions and syntax highlighting.
- 🎮 **Optional flair**: Fastfetch + Pokémon logos.
- 📂 **Custom scripts** support via `~/.scripts`.

---

## **🛠️ Where to Put These Files**

> 📁 Find these in `config/zsh/` of my dotfiles repo.

| **File**    | **Copy To**    | **Purpose**                              |
|-------------|----------------|------------------------------------------|
| `zshrc`     | `~/.zshrc`     | Runs every shell—sets aliases, plugins   |
| `zprofile`  | `~/.zprofile`  | Login shell only—sets PATH, variables    |

```bash
cp ~/dotfiles/config/zsh/zshrc ~/.zshrc
cp ~/dotfiles/config/zsh/zprofile ~/.zprofile
chmod 644 ~/.zshrc ~/.zprofile
```

---

## **📦 Prerequisites & Tools**

Get these installed to make it work smoothly:

### **🔧 Zsh + Plugin Essentials**
```bash
sudo pacman -S zsh git zsh-autosuggestions zsh-syntax-highlighting
```

### **🌟 Oh-My-Zsh (Plugin + Theme Manager)**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### **🎨 Powerlevel10k (Prompt Theme)**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### **🛠️ CLI Tools (For Aliases & Visuals)**
```bash
sudo pacman -S eza xclip tree reflector neofetch timeshift pacman-contrib
yay -S pokemon-colorscripts fastfetch lazygit zoxide yazi
```

- **AUR Helper**: Use `yay` or `paru`. For `yay`:
  ```bash
  sudo pacman -S --needed base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  ```
  Or `paru`:
  ```bash
  sudo pacman -S --needed base-devel git
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  ```
- **MongoDB (optional)**: `sudo pacman -S mongodb && sudo systemctl enable mongod` (useful for database work).

### **📂 Optional Folder**
```bash
mkdir -p ~/.scripts ~/cfg_backups
```

---

## **🧪 After Setup: What You’ll See**

Open a new terminal and enjoy:
- A cute Pokémon logo (if `pokemon-colorscripts` is installed).
- System stats with `fastfetch`.
- A snappy **Powerlevel10k** prompt.
- Autosuggestions and syntax coloring.
- Ready-to-use aliases!

---

## **💡 Example Aliases to Try**

- `update` – Full system update.
- `gs` – Git status.
- `nd` – Run `npm run dev`.
- `pacclean` – Clear old Pacman cache.
- `paccleanall` – Wipe all cached packages.
- `pacckeep` – Keep latest 3 versions.
- `z` – Launch `yazi` (if installed).
- `vc` – Open VS Code.
- `x` – Exit terminal.
- `zfile` – Edit `.zshrc` in Neovim.

All aliases are in `.zshrc`—no extra files needed!

---

## **🧠 How This Works**

- **`.zshrc`**: Loads every terminal. Handles:
  - `$PATH`, `$EDITOR`, `$VISUAL`.
  - Aliases (e.g., `paccache`, `git`, `npm`).
  - Plugins and **Powerlevel10k**.
  - Optional `fastfetch` + Pokémon.
  - `zoxide` for navigation.
  - Note: `vg` (Godot script) is commented out.
- **`.zprofile`**: Runs on login (e.g., Hyprland/TTY). Sets:
  - `$PATH`, `$EDITOR`.
  - Keeps it lightweight.

Everything’s kept tidy in one place!

---

## **🧩 Optional Add-ons (Commented)**

Peek at `.zshrc` for:
- 🔒 **Keybinding Templates**: Bind scripts (e.g., `music.sh`)—uncomment to use.
- 🛠️ **Scripts Folder**: Add your tools to `~/.scripts`.

---

## **✅ Final Check**

- Update `.zprofile` paths with your home dir (e.g., `/home/amitwt/`).
- Test with `update`, `gs`, or `pacclean`.

You’re good to go! Let me know if you tweak it—I’d love to hear how it works for you. 😄

---

*Powered by a double k vibe—check [doublek.dev](https://doublek.dev) for more!*