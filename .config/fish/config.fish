source ~/Documents/github/dotfiles/.config/fish/aliases.fish
source ~/Documents/github/dotfiles/.config/fish/env.fish

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
# zoxide init fish | source #better cd (install with: sudo pacman -S zoxide)
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
end
starship init fish | source #starthip prompt

fish_add_path $HOME/.spicetify
fish_add_path $HOME/.local/bin

# Created by `pipx` on 2025-11-26 21:45:59
# set PATH $PATH $HOME/.local/bin  # Already added with fish_add_path above
