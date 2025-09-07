#!/usr/bin/env bash

function sndio_val() {
  sndioctl "$1" | awk -F'=' '{print $2}'
}

while true; do
  LEVEL=$(sndio_val output.level | bc)
  MUTE=$(sndio_val output.mute)
  if [[ $MUTE -eq 1 ]]; then
    echo 'muted'
  else
    LEVEL=${LEVEL/./}
    echo "$(( LEVEL/10 ))%"
  fi
  sleep 1
done
