#!/usr/bin/bash

# Date and time
date=$(date "+%Y/%m/%d")
formatted_date_and_week=$(date "+%Y, %B %d, Week %V, %A")
current_time=$(date "+%H:%M:%S")

# Battery or charger
battery=$(acpi | cut -d $'\n' -f1 | cut -d " " -f3-)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$battery_status" == "Discharging" ]
then
  battery_pluggedin='🔋'
else
  battery_pluggedin='🔌'
fi

# Volume
volume_and_muted=$(amixer -D pulse get Master | awk -F '[[|]|%]' 'NR==6 { print $2, $4 }' | sed 's/]//g')
volume=$(echo "$volume_and_muted" | cut -d ' ' -f 1)
sound=$(echo "$volume_and_muted" | cut -d ' ' -f 2)

suffix=' %'
prefix=' '

if [ "$sound" = "on" ] # single '=' to compare strings
then
  if [ "$volume" -lt 25 ]
  then
    if [ "$volume" -lt 10 ]
    then
      prefix='  '
    fi
    sound_icon='🔈'
  elif [ "$volume" -lt 75 ]
  then
    sound_icon='🔉'
  else
    if [ "$volume" -eq 100 ]
    then
      prefix=''
    fi
    sound_icon='🔊'
  fi

else
  suffix=''
  prefix=''
  volume='-----'
  sound_icon='🔇'
fi

# Network
network=$(nmcli dev | grep -w "connected" | xargs)
type=$(echo $network | cut -d ' ' -f2)
state=$(echo $network | cut -d ' ' -f3)
connection=$(echo $network | cut -d ' ' -f4)
signal=$(tail -n1 < /proc/net/wireless | awk -F "[ |.]" '{ print int($5 / 0.7) " %" }')

if [ "$state" == "connected" ]
then
  net_icon="1"

  if [ "$type" == "wifi" ]
  then
    net_icon='📶'
    network_status="$connection: $signal"
  else
    net_icon='⏚'
    network_status="Eth"
  fi

else
  network_status="No connection"
fi

echo "| $net_icon $network_status | $sound_icon $prefix$volume$suffix | $battery_pluggedin $battery | 📅 $date | $formatted_date_and_week | 🕘 $current_time |"
