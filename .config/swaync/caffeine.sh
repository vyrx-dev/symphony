#!/bin/bash

# Check status only
if [[ "$1" == "status" ]]; then
    if pidof hypridle > /dev/null; then
        echo "false"  # hypridle running = caffeine OFF
    else
        echo "true"   # hypridle not running = caffeine ON
    fi
    exit 0
fi

# Toggle caffeine mode by killing/starting hypridle
if pidof hypridle > /dev/null; then
    # Hypridle is running - kill it (caffeine mode ON)
    pkill hypridle
    notify-send -a "Caffeine" "☕ Caffeine Mode ON" "Screen will stay awake"
    echo "true"
else
    # Hypridle is not running - start it (caffeine mode OFF)
    hypridle &
    notify-send -a "Caffeine" "💤 Caffeine Mode OFF" "Idle timeout enabled"
    echo "false"
fi
