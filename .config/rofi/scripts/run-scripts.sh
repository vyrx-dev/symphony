#!/usr/bin/env bash
selected=$(ls ~/Scripts/ | rofi -dmenu -p "Run: ") && bash ~/Scripts/$selected
