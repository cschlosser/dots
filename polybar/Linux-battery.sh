#!/usr/bin/env bash

while true; do
  PERCENT=$(cat /sys/class/power_supply/BAT1/capacity)
  MIN_REMAINING=$(acpi -r | cut -d',' -f3 | cut -d':' -f1,2)
  CHARGING=''
  if [[ "$(cat /sys/class/power_supply/BAT1/status)" == "Charging" ]]; then
    CHARGING='+'
  fi
  echo -n "$PERCENT%"
  if [[ ! -z $CHARGING || ! -z $MIN_REMAINING ]]; then
    echo -n " (${CHARGING}${MIN_REMAINING/ /})"
  fi
  echo
  sleep 60
done
