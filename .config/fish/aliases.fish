# ┌─────────┐
# │ Aliases │
# └─────────┘

#General
alias c='clear'
alias l='eza -lh --icons=auto'
alias la='ls -a'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias ltt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias bash='source ~/.bashrc'
alias bfile='nvim ~/.bashrc'
alias ffile='nvim ~/.config/fish/config.fish'
alias fish='source ~/.config/fish/config.fish'
alias xx='tmux'

# change your default USER shell
alias tobash="chsh $USER -s /usr/bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="chsh $USER -s /usr/bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="chsh $USER -s /usr/bin/fish && echo 'Log out and log back in for change to take effect.'"

#When was the Last update
alias last-updated='grep -i "full system upgrade" /var/log/pacman.log | tail -n 1'

# Check cache size
alias cache='du -sh /var/cache/pacman/pkg .cache/yay'

#to open ani cli
alias ac='ani-cli'

#modified commands
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# File finding
alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias fdh='fd --hidden'

# Search files in the current folder
alias f="find . | grep "

#Life Easy
alias vim='nvim'
alias cd='z'
alias nd='npm run dev'
alias n='nvim'
alias open='nautilus .'
alias zz='yazi'
alias lg='lazygit'
alias x='exit'
alias h="history | grep "
alias kt='kitten themes'
alias g='gemini'
alias d='docker'
alias rip="yt-dlp -x --audio-format=\"mp3\""
alias mp='makepkg -si'
alias chx='chmod +x'
alias tmuxk='tmux kill-session'
abbr -a nb 'nvim ~/.config/hypr/bindings.conf'

# bigger font in tty and regular font in tty
alias bigfont="setfont ter-132b"
alias regfont="setfont default8x16"

# Some useful aliases
alias update='sudo pacman -Syu'
alias pwreset='faillock --reset --user vyrx'
alias pg='ping -c 10 google.com'

# Automatically do an ls after each cd, z, or zoxide
alias cleanup='sudo pacman -Rns $(pacman -Qdtq)'
alias showpkg='pacman -Qi' # Show package info
alias mirrorfix='sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist' # Fix mirrors
alias pacclean='sudo paccache -r' # Clean all but latest 3 versions
alias paccleanall='sudo paccache -r -c /var/cache/pacman/pkg -u' # Clean all cached packages
alias pacckeep='sudo paccache -k 3' # Keep latest 3 versions, remove rest
alias cleanc='sudo pacman -Sc && yay -Sc'
alias folders='du -h --max-depth=1'

# Git aliases
alias gits='git status'
alias ghs='streaker vyrx-dev'
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
