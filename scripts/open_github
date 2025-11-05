#!/usr/bin/env bash

# Open the current repository in the browser

# Get current tmux pane directory or fallback to pwd
if [ -n "$TMUX" ]; then
  path=$(tmux display-message -p "#{pane_current_path}")
else
  path=$(pwd)
fi

cd "$path" || {
  echo "Failed to cd into $path"
  exit 1
}

url=$(git remote get-url origin 2>/dev/null)

if [[ $url == *github.com* ]]; then
  if [[ $url == git@* ]]; then
    url="${url#git@}"
    url="${url/:/\/}"
    url="https://$url"
  fi
  xdg-open "$url"
else
  echo "This repository is not hosted on GitHub"
fi
