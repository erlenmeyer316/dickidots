#!/usr/bin/env bash

i3status -c ~/.config/i3/i3status/config 
#| {
#  read -r header; echo "$header"
#  read -r bracket; echo "$bracket"
#  first=1
#  while read -r line; do 
#    line=${line#,}
#    line=${line%,}
#    bri=$(brightnessctl -m 2>/dev/null | cut -d, -f4)
#    bri=${bri:-N/A}
#    n=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
#    if [ "$n" -gt 0 ]; then bt=" $n"; else bt=""; fi 
#    out=$(jq -c --arg b " $bri" --arg bt "$bt" '
#          [{name:"brightness",full_text:$b}]
#          + (if $bt != "" then [{name:"bluetooth",full_text:$bt}] else [] end)
#          + .' <<<"$line")
#    if [ $first -eq 1 ]; then echo "$out"; first=0; else echo ",$out"; fi
#  done
#}
