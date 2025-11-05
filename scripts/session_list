#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')

# Get windows of current session with index and name
windows=$(tmux list-windows -t "$current_session" -F '#I: #W')

# Select a window interactively
selected=$(echo "$windows" | fzf --prompt="Switch window in $current_session> ")

if [[ -n $selected ]]; then
  window_index=${selected%%:*}
  tmux select-window -t "${current_session}:$window_index"
fi
