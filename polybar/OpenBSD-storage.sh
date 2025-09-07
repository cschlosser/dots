#!/usr/bin/env bash

function print_line() {
  echo -n "%{F#555}$1: %{F-}$2 "
}

while true; do
  while IFS= read -r LINE; do
    PART="$(awk '{print $1}' <<< $LINE)"
    PERC="$(awk '{print $5}' <<< $LINE)"
    print_line ${PART: -1} $PERC
  done <<< "$(df | grep '/dev/' | sort)"
  echo
  sleep 5
done
