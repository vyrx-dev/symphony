#!/bin/bash

if grep -q 'background_opacity 0.8' ~/.config/kitty/kitty.conf; then
  sed -i 's/background_opacity 0.8/background_opacity 1/g' ~/.config/kitty/kitty.conf
  echo "Done! set to 1.0"
elif grep -q 'background_opacity 1' ~/.config/kitty/kitty.conf; then
  sed -i 's/background_opacity 1/background_opacity 0.8/g' ~/.config/kitty/kitty.conf
  echo "Done! set to 0.8"
else
  echo "There is no background_opacity is present in the kitty theme...😥"
fi

pkill -SIGUSR1 -x kitty 2>/dev/null
