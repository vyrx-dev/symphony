# Pending Tasks

## 1. Move all config scripts into `bin/`

Scripts currently scattered across 3 directories:
- `config/hypr/scripts/` — 27 scripts
- `config/rofi/scripts/` — 12 scripts
- `config/waybar/scripts/` — 4 scripts

Move all 43 into `bin/`. One conflict: `restart-app` exists in both `bin/` and `config/hypr/scripts/` — compare and keep the right one.

### References to update (~30 occurrences)

**Hyprland configs:**
- `config/hypr/autostart.conf` — `battery-notify`, `first-run`
- `config/hypr/bindings.conf` — `launch-browser`, `launch-webapp`, `focus`
- `config/hypr/hypridle.conf` — `lock-screen`, `screensaver-launch`

**Self-references inside scripts:**
- `screensaver-launch` → references `screensaver`
- `webapp-install` → references `launch-webapp`

**Waybar:**
- `config/waybar/config.jsonc` — `rofibeats`, `screenrecord`, `indicator-record`, `indicator-idle`, `toggle-idle`, `wall-picker`, `random-wall`, `power-profiles`

**Fish env:**
- `config/fish/env.fish` — PATH entries for `waybar/scripts` and `rofi/scripts` (remove — bin/ already in PATH)

**Install scripts:**
- `install/themes/symphony` — `change-theme`, `themePicker`
- `install/webapps.sh` — `webapp-install`
- `bin/theme-showcase` — `change-theme`

**Pattern:** All refs use `~/.config/{hypr,rofi,waybar}/scripts/name`. After move, scripts live in `~/.local/bin/` (deploy target for `bin/`), which is already in PATH. So refs become just the script name or `~/.local/bin/name`.

---

## 2. Replace `config/tmux/` with single `.tmux.conf`

Current: `config/tmux/tmux.conf`, `statusline.conf`, `utility.conf`
Replace with: `~/workspace/.tmux.conf` (single file)
Deploy to: `~/.tmux.conf`

---

## 3. Update TODO.md

- Tick: Neovim cleanup (done — replaced with workspace config)
- Add + tick: Single tmux file for all configuration

---

## 4. Delete old directories

- `config/hypr/scripts/`
- `config/rofi/scripts/`
- `config/waybar/scripts/`
- `config/tmux/`

---

## 5. Do NOT commit/push yet — just stage changes
