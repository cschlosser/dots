#!/usr/bin/env bash

time_fmt() {
  MINUTES=$1
  if [[ $MINUTES -ge 60 ]]; then
    ((h=${MINUTES}/60))
    ((m=${MINUTES}%60))
    if [[ $h -ge 99 ]]; then
      echo -n "long"
    else
      printf "%02d:%02d" $h $m
    fi
  elif [[ "$MINUTES" != 'unknown' ]]; then
    echo -n "${MINUTES}m"
  fi
}

while true; do
  PERCENT=$(apm -l)
  MIN_REMAINING=$(time_fmt $(apm -m))
  CHARGING=''
  if [[ "$(apm -b)" -eq 3 ]]; then
    CHARGING='+'
  fi
  echo "$PERCENT% (${CHARGING}${MIN_REMAINING})"
  sleep 60
done
