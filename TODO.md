```
  ____                        _                           _____   ___
 / ___| _   _ _ __ ___  _ __ | |__   ___  _ __  _   _    |___ /  / _ \
 \___ \| | | | '_ ` _ \| '_ \| '_ \ / _ \| '_ \| | | |     |_ \ | | |
  ___) | |_| | | | | | | |_) | | | | (_) | | | | |_| |    ___) || |_| |
 |____/ \__, |_| |_| |_| .__/|_| |_|\___/|_| |_|\__, |   |____(_)\___/
        |___/          |_|                      |___/
```

**Status**: In Development  
**Current**: [v3.0.0](https://github.com/vyrx-dev/symphony/releases/tag/v3.0.0)  
**Previous**: [v2.1.0](https://github.com/vyrx-dev/symphony/releases/tag/v2.1.0)

---

## v3.0.0

- [x] Omarchy themes import (`symphony import`)
- [x] Symphony TUI (`symphony tui`) - web apps, choose shell, browse/import themes
- [x] Theme installer visual redesign with Symphony branding
- [x] Error handling with Discord QR and GitHub link
- [x] Shell chooser in install flow
- [x] Hyprland v0.53.0 rule syntax migration
- [x] Yazi 25.x theme format update
- [x] Improved shadow and decoration settings
- [x] Theme switcher with preview
- [x] Spicetify theming
- [x] Battery notification daemon
- [x] Dynamic webapp installer (CDN icons, no bundled files)
- [x] Fixed first-run script and startup file generation
- [x] Modularize symphony-import config generators into per-app files
- [x] Replaced stow with cp-based deployment (`deploy.sh`) + automatic backups
- [x] Flatten directory structure (`.config/` → `config/`, `scripts/` → `bin/`)
- [x] Flatten theme directory paths (removed nested `.config/`)
- [x] All install scripts independently runnable
- [x] Webapps offered during install flow
- [x] Services.sh bug fixes (systemctl syntax, git check)
- [x] Deploy.sh / uninstall.sh flat bin iteration fix
- [x] Symphony CLI — `update`, `restore`, `fresh-setup` commands
- [x] README rewrite — natural tone, troubleshooting, rolled release disclaimer
- [x] Renamed `dotfiles` → `symphony` across all files and variables (`SYMPHONY_DIR`)
- [x] SDDM setup (SilentSDDM integration in post-setup.sh)
- [x] Fixed symphony-import to use flattened theme structure (no `.config/` nesting)
- [x] Staged first-run flow (theme install → reboot → welcome notifications)
- [x] Neovim cleanup (replaced with workspace config)
- [x] Single tmux.conf — replaced multi-file config/tmux/ with one file
- [x] Consolidated all scripts into `bin/` (from hypr/rofi/waybar script dirs)
- [ ] Symphony TUI — improve UX (wallpaper preview, more actions)
- [x] Theme template system — generate configs from `.tpl` + `colors.toml`
- [ ] README — compress showcase GIFs or convert to video links
- [ ] QT theming (kvantum/qt5ct)

---

## Backlog


- [ ] Media conversion scripts
- [ ] Symphony website


---

_Last updated: February 22, 2026_
