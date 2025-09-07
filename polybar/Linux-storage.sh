#!/usr/bin/env bash

function print_line() {
  echo -n "%{F#555}$1: %{F-}$2 "
}

while true; do
  for l in void-os void-home; do
    LINE=$(df | grep "$l")
    PART="$(awk '{print $1}' <<< $LINE)"
    PERC="$(awk '{print $5}' <<< $LINE)"
    print_line $(awk -F'-' '{print $2}' <<< $PART) $PERC
  done
  echo
  sleep 5
done
