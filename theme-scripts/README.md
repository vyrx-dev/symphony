# Symphony Theme System

A unified theme management system for your Linux desktop. Switch between beautiful themes instantly with a single command.

---

## Quick Start

```bash
# Switch themes (opens menu)
symphony-theme switch

# List all themes
symphony-theme list

# Remove a theme
symphony-theme remove zen

# Fix broken colors
symphony-theme fix

# Show all commands
symphony-theme help
```

**Keyboard shortcuts:** Already configured in `~/.config/hypr/bindings.conf`

**Theme Management:**
```bash
SUPER+CTRL+SHIFT+SPACE          # Theme switcher (rofi menu)
symphony-theme list             # Show all installed themes (terminal)
```

**Wallpaper Pickers:**
```bash
SUPER+ALT+SPACE                 # Wallpaper picker (all themes, swww only)
SUPER+CTRL+SPACE                # Matugen wallpaper picker (generates colors)
CTRL+ALT+SPACE                  # Random matugen wallpaper (matugen only)
```

**Cycle Through Wallpapers:**
```bash
SUPER+ALT+RIGHT                 # Next wallpaper in current theme folder
SUPER+ALT+LEFT                  # Previous wallpaper in current theme folder
```

**Other:**
```bash
SUPER+SHIFT+P                   # Color picker (hyprpicker)
```

---

## How It Works

The system uses **symlinks** to connect theme files to your config folders.

```
~/dotfiles/themes/          → Your theme collection
    ├── zen/
    ├── sakura/
    ├── tokyo-night/
    └── matugen/           → Dynamic (wallpaper-based)

~/.config/                 → Active theme (symlinks)
    ├── hypr/theme/colors.conf
    ├── kitty/colors.conf
    └── ...
```

When you switch themes, the system:
1. Removes old symlinks
2. Creates new symlinks to the chosen theme
3. Changes wallpaper
4. Reloads all applications
5. Shows a notification

---

## Installation

**Quick install (with animations):**
```bash
cd ~/dotfiles
bash theme-scripts/install-symphony-gum.sh
```

**Standard install:**
```bash
cd ~/dotfiles
bash theme-scripts/install-symphony-themes.sh
```

**After installation:**
```bash
# Reload your shell
source ~/.zshrc  # or ~/.bashrc

# Switch to your first theme
symphony-theme switch
```

---

## Adding a New Theme

### Easy Method (Copy Existing Theme)

```bash
# 1. Copy a theme as template
cp -r ~/dotfiles/themes/zen ~/dotfiles/themes/my-theme

# 2. Edit the colors in these files:
cd ~/dotfiles/themes/my-theme/.config
# - hypr/theme/colors.conf
# - kitty/colors.conf
# - alacritty/colors.toml
# - rofi/colors.rasi
# - cava (one color per line)

# 3. Replace wallpaper
rm backgrounds/*
cp /path/to/your-wallpaper.jpg backgrounds/

# 4. Generate additional files
symphony-theme generate-all

# 5. Test your theme
symphony-theme switch
```

### Manual Method (From Scratch)

```bash
# 1. Create folder structure
THEME="my-theme"
mkdir -p ~/dotfiles/themes/$THEME/.config/{hypr/theme,kitty,alacritty,rofi,rmpc/themes}
mkdir ~/dotfiles/themes/$THEME/backgrounds

# 2. Create color files (see existing themes for examples)
nano ~/dotfiles/themes/$THEME/.config/hypr/theme/colors.conf
nano ~/dotfiles/themes/$THEME/.config/kitty/colors.conf
nano ~/dotfiles/themes/$THEME/.config/alacritty/colors.toml
nano ~/dotfiles/themes/$THEME/.config/rofi/colors.rasi
nano ~/dotfiles/themes/$THEME/.config/cava

# 3. Add wallpaper
cp wallpaper.jpg ~/dotfiles/themes/$THEME/backgrounds/

# 4. Generate remaining configs
symphony-theme generate-all

# 5. Switch to your theme
symphony-theme switch
```

---

## Removing a Theme

**Easy way (with confirmation):**
```bash
symphony-theme remove theme-name
```

**Manual way:**
```bash
# 1. Switch to a different theme first
symphony-theme switch

# 2. Delete the theme folder
rm -rf ~/dotfiles/themes/theme-name
```

---

## Two Theme Modes

### Custom Themes (Static Colors)
- Fixed color schemes that never change
- Perfect for carefully crafted aesthetics
- Examples: zen, sakura, tokyo-night, carnage
- Change wallpaper anytime: `SUPER+ALT+SPACE` (wallPicker)

### Matugen (Dynamic Colors)
- Colors generated from your wallpaper
- Changes automatically when you change wallpaper
- Uses Material Design 3 color system

**To use matugen:**
```bash
symphony-theme switch           # Select "matugen"
# SUPER+CTRL+SPACE              # Pick wallpaper → colors update automatically
```

**To use static themes:**
```bash
symphony-theme switch           # Select any custom theme (zen, sakura, etc.)
# SUPER+ALT+SPACE               # Change wallpaper (keeps theme colors)
```

**Wallpaper controls:**
```bash
SUPER+ALT+SPACE                 # Wallpaper picker (all themes, swww only)
SUPER+CTRL+SPACE                # Matugen picker (generates colors from wallpaper)
CTRL+ALT+SPACE                  # Random matugen wallpaper (matugen only)
SUPER+ALT+RIGHT/LEFT            # Cycle wallpapers in current theme folder
swww img /path/to/image.jpg     # Manual wallpaper change
```

---

## Commands

| Command | What It Does |
|---------|-------------|
| `symphony-theme switch` | Open theme menu and switch |
| `symphony-theme list` | Show all installed themes |
| `symphony-theme remove <name>` | Remove a theme |
| `symphony-theme fix` | Fix broken symlinks |
| `symphony-theme generate-all` | Regenerate all theme configs |
| `symphony-theme generate-starship` | Regenerate prompt configs |
| `symphony-theme generate-cava` | Regenerate visualizer configs |
| `symphony-theme generate-rmpc` | Regenerate music player themes |
| `symphony-theme help` | Show help message |

---

## Troubleshooting

### Colors look wrong
```bash
symphony-theme fix
```

### Theme won't switch
```bash
# Check current theme
cat ~/.current-theme

# Manually switch
cd ~/dotfiles/themes
stow -D old-theme
stow new-theme
echo "new-theme" > ~/.current-theme
hyprctl reload
```

### Wallpaper picker not working

**Two wallpaper pickers available:**

1. **wallPicker** (`SUPER+ALT+SPACE`) - Works with ALL themes
   - Just changes wallpaper using swww
   - Keeps your theme colors intact
   - Use this for custom themes

2. **selectWall** (`SUPER+CTRL+SPACE`) - Matugen only
   - Generates new colors from wallpaper
   - Only works when matugen theme is active
   - Blocked on custom themes to protect your colors

**If selectWall is blocked:**
```bash
# Switch to matugen first
symphony-theme switch  # Select "matugen"
# SUPER+CTRL+SPACE     # Now works
```

**Or use wallPicker instead:**
```bash
# SUPER+ALT+SPACE      # Works with any theme
```

---

## What's Included

Each theme contains color configurations for:
- **Hyprland** - Window manager colors
- **Kitty/Alacritty** - Terminal colors
- **Rofi** - Application launcher colors
- **Cava** - Audio visualizer gradient
- **RMPC** - Music player theme
- **Starship** - Command prompt colors
- **Wallpaper(s)** - Matching backgrounds

---

**System Version:** 2.1  
**Location:** `~/dotfiles/theme-scripts/`  
**Command:** `symphony-theme` (or `theme` for backward compatibility)

---

## Vesktop Theme Support

### How It Works

Every theme (including matugen) now has full Vesktop/Discord theme support using the Midnight Discord base theme with your theme colors.

**When you switch themes:**
- The Vesktop theme automatically updates to match your current theme colors
- No manual intervention needed!

### Commands

```bash
# Switch themes (includes Vesktop)
symphony-theme switch
# or use: SUPER+CTRL+SHIFT+SPACE

# Regenerate Vesktop themes for all static themes
symphony-theme generate-vesktop

# Regenerate all configs (includes Vesktop)
symphony-theme generate-all
```

### Adding Vesktop to a New Theme

When you create a new theme, Vesktop theme generation is automatic:

```bash
# After creating your theme structure
symphony-theme generate-all
# or
symphony-theme generate-vesktop
```

The generator extracts colors from your theme's:
- Alacritty config (background, foreground, accent colors)
- Btop theme (theme-matched highlights and colors)

### Matugen Support

Matugen themes work seamlessly:
- Matugen generates Vesktop theme from wallpaper colors automatically
- Uses Material Design 3 color system
- Stored in `themes/matugen/.config/vesktop/themes/`
- No special handling needed when switching!

### Troubleshooting

**Vesktop theme not updating?**
```bash
# Check if theme has vesktop file
ls -la ~/dotfiles/themes/[YOUR_THEME]/.config/vesktop/themes/

# Regenerate if missing
symphony-theme generate-vesktop

# Switch theme again
symphony-theme switch
```

**Colors look wrong?**
```bash
# Regenerate all configs
symphony-theme generate-all

# Fix broken symlinks
symphony-theme fix
```

---

