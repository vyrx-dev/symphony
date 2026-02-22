source ~/.config/fish/aliases.fish
source ~/.config/fish/env.fish
# source ~/.config/fish/api.fish

### EXPORT ###
set -g fish_greeting ""
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="nvim"
export TERMINAL="kitty"

export MANPAGER="nvim +Man!"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'" # man using bat

# Key bindings
fish_default_key_bindings
# fish_vi_key_bindings

# Tool integrations
fzf --fish | source
zoxide init fish | source
starship init fish | source

# User paths
fish_add_path ~/.local/bin
fish_add_path ~/.spicetify

# Symphony
set -gx PATH /home/vyrx/symphony/install/themes $PATH
