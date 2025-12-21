#!/bin/bash
# Hyprland - reload config
pgrep -x Hyprland &>/dev/null && hyprctl reload &>/dev/null || exit 0
