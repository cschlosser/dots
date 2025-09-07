#!/usr/bin/env bash

PW_AUDIO_OUT=57

while true; do
  LEVEL=$(wpctl get-volume $PW_AUDIO_OUT 2> /dev/null | cut -d' ' -f2,3)
  MUTED=$(echo "$LEVEL" | grep -q '[MUTED]'; echo $?)
  if [[ $MUTED -eq 0 ]]; then
    echo 'muted'
  else
    echo "$(bc <<< ${LEVEL/./})%"
  fi
  sleep 1
done
