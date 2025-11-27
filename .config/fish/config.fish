source ~/dotfiles/.config/fish/aliases.fish
source ~/dotfiles/.config/fish/env.fish

### EXPORT ###
set -g fish_greeting ""
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="nvim"

export MANPAGER="nvim  +Man!"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'" # man using bat

# Choose any one binds settings
# fish_vi_key_bindings
fish_default_key_bindings

fzf --fish | source # fzf keybinding
zoxide init fish | source #better cd
starship init fish | source #starthip prompt

fish_add_path /home/vyrx/.spicetify


# Created by `pipx` on 2025-11-26 21:45:59
set PATH $PATH /home/vyrx/.local/bin
