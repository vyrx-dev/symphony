# [A clean, structured zsh setup with productivity tools and a personal flair]

# ┌──────────────────────┐
# │ Oh-My-Zsh Settings   │
# └──────────────────────┘
# [Configures Oh-My-Zsh framework for shell enhancements]
ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
ZSH_THEME="robbyrussell"

plugins=(
    git
    sudo
    zsh-256color
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# ┌───────────┐
# │ Functions │
# └───────────┘
# [Custom functions to extend shell capabilities]

# Detect AUR helper with fallback
aurhelper="yay"  # Default to yay
if ! pacman -Qi yay &>/dev/null && ! pacman -Qi paru &>/dev/null; then
    echo "Warning: Neither yay nor paru is installed. AUR aliases (e.g., up, un) won't work until you install an AUR helper."
else
    if pacman -Qi yay &>/dev/null; then
        aurhelper="yay"
    elif pacman -Qi paru &>/dev/null; then
        aurhelper="paru"
    fi
fi

# Command not found handler
# [Handles unrecognized commands by suggesting installable packages]
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )); then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Install function
function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        if command -v $aurhelper >/dev/null; then
            $aurhelper -S "${aur[@]}"
        else
            echo "Error: AUR helper ($aurhelper) not found. Install yay or paru to use AUR packages."
        fi
    fi
}

# ┌─────────┐
# │ Aliases │
# └─────────┘
# [Shortcuts for common commands to save time]

# Package management
alias in='in'
alias un='$aurhelper -Rns'
alias up='$aurhelper -Syu'
alias pl='$aurhelper -Qs'
alias pa='$aurhelper -Ss'
alias pc='$aurhelper -Sc'
alias po='$aurhelper -Qtdq | $aurhelper -Rns -'
  
# General
alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias fastfetch='fastfetch --logo none --color dark --structure "title:os:host:kernel:uptime:battery:cpu:memory:temp"'

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

# Custom aliases
# [Personal shortcuts, adjust or replace with your own]
alias zz='nvim'              # Open neovim
alias vi='nvim'              # Alias for neovim
alias vc='code'
alias gcalm='gcalcli calm'
alias gcalw='gcalcli calw'
alias last-updated='grep -i "full system upgrade" /var/log/pacman.log | tail -n 1'
alias ac='ani-cli'  # to open ani-cli
#alias vg='nvim-godot.sh'     # Open Godot script in neovim
alias t='tree -L 1'          # Show directory tree (level 1)
alias nd='npm run dev'       # Run npm dev script
alias open='dolphin'         # Open file manager
alias cache='du -sh /var/cache/pacman/pkg .cache/yay'  # Check cache size
alias z='yazi'               # Launch yazi file manager
alias lg='lazygit'           # Launch lazygit (duplicate for consistency)
alias x='exit' # exit the teminal
alias zfile='nvim ~/.config/zsh/.zshrc'  # Zsh config file  or ~/.zshrc
alias shader='.local/lib/hyde/./shaders.sh --select'   # shader switch for HyDE

# Productivity aliases (inspired by Arch/Hyprland/Linux workflows)
# [Useful commands for system and workflow efficiency]
alias upd='up && fastfetch'  # Update system and show info
alias snap='timeshift --create --comments "Manual Backup"'  # Create system snapshot
alias logc='tail -f /var/log/pacman.log'  # Monitor pacman logs

# Git aliases
# [Git shortcuts for version control]
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'

# Some useful aliases
# [Handy commands, modify or replace with your scripts]
alias update='sudo pacman -Syu'        # Update Arch system
alias cleanup='sudo pacman -Rns $(pacman -Qdtq)'  # Clean unused packages
alias findpkg='pacman -Ss'              # Search for packages
alias showpkg='pacman -Qi'              # Show package info
alias mirrorfix='sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist'  # Fix mirrors
alias ns='npm start'                    # Start npm project
alias ni='npm install'                  # Install npm dependencies
alias nid='npm install --save-dev'      # Install dev dependencies
alias nr='npm run'                      # Run npm script
alias npkg='npm list --depth=0'         # List installed packages
alias path='echo $PATH | tr ":" "\n"'   # Display PATH
alias pacclean='sudo paccache -r'       # Clean all but latest 3 versions
alias paccleanall='sudo paccache -r -c /var/cache/pacman/pkg -u'  # Clean all cached packages
alias pacckeep='sudo paccache -k 3'     # Keep latest 3 versions, remove rest
alias cleanc='sudo pacman -Sc && yay -Sc'
alias dot='cd ~/dotfiles/'

# ┌──────────────────────┐
# │ Keybindings          │
# └──────────────────────┘
# [Custom key combinations to run scripts or commands]
# Template 1: Simple script execution (replace KEY and PATH)
# bindkey -s KEY "path/to/script.sh\n"
# Example: bindkey -s ^m "~/.scripts/music.sh\n"
# [Runs script when KEY is pressed; add your script path]

# Template 2: Script with confirmation (replace KEY and PATH)
# bindkey -s KEY 'echo -n "Run script? (y/n) "; read answer; if [[ $answer = y ]]; then path/to/script.sh; fi\n'
# Example: bindkey -s ^n 'echo -n "Run music.sh? (y/n) "; read answer; if [[ $answer = y ]]; then ~/.scripts/music.sh; fi\n'
# [Prompts yes/no before running; customize key and path]

# Template 3: (Optional) Run with argument (replace KEY, PATH, ARG)
# bindkey -s KEY 'path/to/script.sh ARG\n'
# Example: bindkey -s ^p '~/.scripts/music.sh play\n'
# [Passes ARG to script; adjust key, path, and argument]

# ┌──────────────────────┐
# │ Shell Customization  │
# └──────────────────────┘
# [Personalizes the shell experience]
# Load zprofile
source ~/.zprofile

# Display random Pokémon and system info
if command -v pokemon-colorscripts >/dev/null; then
    pokemon-colorscripts --no-title -r 1,3,6
fi
if command -v fastfetch >/dev/null; then
    fastfetch --logo none --color dark --structure "title:os:host:kernel:uptime:battery:cpu:memory:temp"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export VISUAL=nvim
export EDITOR=nvim

#zoxide :wq
eval "$(zoxide init zsh)"
