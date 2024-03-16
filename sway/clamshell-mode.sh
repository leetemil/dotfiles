#!/usr/bin/bash

# this scipt is to prevent closed display reset when reconfiguring sway
# source: https://github.com/swaywm/sway/wiki#clamshell-mode
if grep -q open /proc/acpi/button/lid/LID/state; then
    swaymsg output 'eDP-1' enable
else
    swaymsg output 'eDP-1' disable
fi
