#!/bin/bash

cd "$HOME/Documents/testing" || exit

echo "Enter git repository URL to clone:"
read repo_url

git clone "$repo_url"

repo_name=$(basename -s .git "$repo_url")

if ! tmux has-session -t "$repo_name" 2>/dev/null; then
  tmux new-session -ds "$repo_name" -c "$HOME/Documents/testing/$repo_name"
fi

tmux switch-client -t "$repo_name"
