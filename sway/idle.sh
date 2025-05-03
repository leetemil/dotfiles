#!/usr/bin/bash
swayidle -w \
  timeout 300 "(pactl list | grep RUNNING) || $HOME/.config/sway/lock.sh" \
  timeout 600 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"' \
  before-sleep "$HOME/.config/sway/lock.sh"
