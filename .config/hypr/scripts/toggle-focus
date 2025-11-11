#!/bin/bash

STATE_FILE="/tmp/focus-mode-state"

workspace_id=$(hyprctl activeworkspace -j | jq -r .id)
gaps=$(hyprctl workspacerules -j | jq -r ".[] | select(.workspaceString == \"$workspace_id\") | .gapsOut[0] // 0")

if [[ $gaps == "0" ]]; then
  # Switch to Vibe Mode
  hyprctl keyword "workspace $workspace_id, gapsout:3, gapsin:2, bordersize:1"
  hyprctl keyword animations:enabled true

  sed -i 's/background_opacity 1$/background_opacity 0.8/g' ~/.config/kitty/kitty.conf
  pkill -SIGUSR1 -x kitty

  rm -f "$STATE_FILE"
  notify-send "🌊 Vibe Mode" "Animations and gaps enabled"
else
  # Switch to Focus Mode
  hyprctl keyword "workspace $workspace_id, gapsout:0, gapsin:0, bordersize:1"
  hyprctl keyword animations:enabled false

  sed -i 's/background_opacity 0\.8$/background_opacity 1/g' ~/.config/kitty/kitty.conf
  pkill -SIGUSR1 -x kitty

  touch "$STATE_FILE"
  notify-send "🎯 Focus Mode" "Distractions minimized"
fi
