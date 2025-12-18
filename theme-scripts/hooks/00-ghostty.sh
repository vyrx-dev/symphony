#!/bin/bash
# ghostty - reload colors
pgrep -x ghostty &>/dev/null || exit 0
killall -SIGUSR2 ghostty 2>/dev/null
