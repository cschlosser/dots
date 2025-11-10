#!/usr/bin/env bash

function print_line() {
  echo -n "%{F#555}$1: %{F-}$2 "
}

while true; do
  while IFS= read -r LINE; do
    PART="$(awk '{print $1}' <<< $LINE)"
    PERC="$(awk '{print $5}' <<< $LINE)"
    if [[ "${PART: -1}" != "d" && \
      "${PERC:: -1}" -le 50 ]]; then
        continue
    fi
    MNT="$(awk '{print $6}' <<< $LINE)"
    print_line "${MNT}" "${PERC}"
  done <<< "$(df | grep '/dev/' | sort)"
  echo
  sleep 5
done
