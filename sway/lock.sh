IMAGE=/tmp/swaylock.png
grimshot save output $IMAGE
convert $IMAGE -blur "0x8" $IMAGE
swaylock -f -i $IMAGE
rm $IMAGE
