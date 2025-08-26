# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc
#
# if [ -f /usr/bin/fastfetch ]; then
#   fastfetch
# fi

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias snano='sudo nano'
alias vim='nvim'

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
# alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias svi='sudo vi'
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
alias cd='z'
alias nd='npm run dev'
alias open='nautilus'
alias zz='yazi'
alias lg='lazygit'
alias x='exit'
alias h="history | grep "
alias dot='cd ~/dotfiles/'
alias kt='kitten themes'
alias g='git'
alias d='docker'

# bigger font in tty and regular font in tty
alias bigfont="setfont ter-131b"
alias regfont="setfont default9x16"

# Some useful aliases
alias update='sudo pacman -Syu'
alias pwreset='faillock --reset --user april'

# Automatically do an ls after each cd, z, or zoxide
alias cleanup='sudo pacman -Rns $(pacman -Qdtq)'
alias showpkg='pacman -Qi'                                                               # Show package info
alias mirrorfix='sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist' # Fix mirrors
alias pacclean='sudo paccache -r'                                                        # Clean all but latest 3 versions
alias paccleanall='sudo paccache -r -c /var/cache/pacman/pkg -u'                         # Clean all cached packages
alias pacckeep='sudo paccache -k 3'                                                      # Keep latest 3 versions, remove rest
alias cleanc='sudo pacman -Sc && yay -Sc'
alias folders='du -h --max-depth=1'

# Git aliases
alias gits='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias ghs='streaker theamit-969'

# Create and go to the directory
mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

# cd() {
#   if [ -n "$1" ]; then
#     builtin cd "$@" && ls
#   else
#     builtin cd ~ && ls
#   fi
# }

eval "$(starship init bash)"
eval "$(zoxide init bash)"

export PATH=$PATH:/home/april/.spicetify
