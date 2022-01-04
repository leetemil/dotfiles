IMAGE=/tmp/swaylock.png
DURATION=10
swayidle -w \
    timeout $DURATION "pactl list | grep RUNNING || ~/.config/sway/lock.sh" \
    timeout $(expr $DURATION \* 2) 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep "~/.config/sway/lock.sh"
