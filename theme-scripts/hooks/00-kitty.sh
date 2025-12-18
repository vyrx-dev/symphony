#!/bin/bash
# Kitty - reload colors
pgrep -x kitty &>/dev/null && killall -SIGUSR1 kitty || exit 0
