# ┌─────────┐
# │ Aliases │
# └─────────┘

#General
alias ls='eza -1 --icons=auto'
alias l='eza -lh --icons=auto'
alias zed='zeditor'
abbr -a c clear
abbr -a la 'ls -a'
abbr -a ll 'eza -lha --icons=auto --sort=name --group-directories-first'
abbr -a ld 'eza -lhD --icons=auto'
abbr -a lt 'eza --icons=auto --tree'
abbr -a ltt 'eza --tree --level=2 --long --icons --git'
abbr -a lta 'lt -a'
# abbr -a bash 'source ~/.bashrc'
abbr -a bfile 'nvim ~/.bashrc'
abbr -a ffile 'nvim ~/.config/fish/config.fish'
# abbr -a fish 'source ~/.config/fish/config.fish'
abbr -a xx tmux

# change your default USER shell
alias tobash="chsh $USER -s /usr/bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="chsh $USER -s /usr/bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="chsh $USER -s /usr/bin/fish && echo 'Log out and log back in for change to take effect.'"

#When was the Last update
alias last-updated='grep -i "full system upgrade" /var/log/pacman.log | tail -n 1'

# Check cache size
abbr -a cache 'du -sh /var/cache/pacman/pkg .cache/yay'

#to open ani cli
abbr -a ac ani-cli

#modified commands
abbr -a cp 'cp -i'
abbr -a mv 'mv -i'
abbr -a mkdir 'mkdir -p'
abbr -a ping 'ping -c 10'
abbr -a yayf "yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# File finding
abbr -a ff 'find . -type f -name'
abbr -a fd 'find . -type d -name'
abbr -a fdh 'fd --hidden'

# Search files in the current folder
abbr -a f "find . | grep "

#Life Easy
alias cd='z'
abbr -a vim nvim
abbr -a nd 'npm run dev'
abbr -a n nvim
abbr -a open 'nautilus .'
abbr -a zz yazi
abbr -a lg lazygit
abbr -a x exit
abbr -a h "history | grep "
abbr -a kt 'kitten themes'
abbr -a g gemini
abbr -a d docker
abbr -a rip "yt-dlp -x --audio-format=\"mp3\""
abbr -a mp 'makepkg -si'
abbr -a chx 'chmod +x'
abbr -a tmuxk 'tmux kill-session'
abbr -a nb 'nvim ~/.config/hypr/bindings.conf'

# bigger font in tty and regular font in tty
abbr -a bigfont "setfont ter-132b"
abbr -a regfont "setfont default8x16"

# Some useful aliases
abbr -a update 'sudo pacman -Syu'
abbr -a pwreset 'faillock --reset --user vyrx'
abbr -a pg 'ping -c 10 google.com'

# Automatically do an ls after each cd, z, or zoxide
abbr -a cleanup 'sudo pacman -Rns $(pacman -Qdtq)'
abbr -a showpkg 'pacman -Qi' # Show package info
abbr -a mirrorfix 'sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist' # Fix mirrors
abbr -a pacclean 'sudo paccache -r' # Clean all but latest 3 versions
abbr -a paccleanall 'sudo paccache -r -c /var/cache/pacman/pkg -u' # Clean all cached packages
abbr -a pacckeep 'sudo paccache -k 3' # Keep latest 3 versions, remove rest
abbr -a cleanc 'sudo pacman -Sc && yay -Sc'
abbr -a folders 'du -h --max-depth=1'

# Git aliases
abbr -a gits 'git status'
abbr -a ghs 'streaker vyrx-dev'
abbr -a ghp 'gh repo create --public $(basename "$PWD") --source=. --description="desc" --push'

# Grub Update
abbr -a update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Snapper
abbr -a slsr 'sudo snapper -c root list'
abbr -a slsh 'sudo snapper -c home list'
abbr -a sdu 'sudo btrfs filesystem du -s /.snapshots/*'
abbr -a sdelr 'sudo snapper -c root delete'
abbr -a sdelh 'sudo snapper -c home delete --sync' #eg  --sync 1 or 2-4
abbr -a sbdel 'sudo btrfs subvolume delete' #eg  sudo btrfs subvolume delete /.snapshots/5/snapshot
