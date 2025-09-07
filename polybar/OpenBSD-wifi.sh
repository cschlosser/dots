#!/usr/bin/env bash

IF=iwx0

while true; do
  WIFI_STATUS=$(ifconfig $IF | grep status | awk -F': ' '{print $2}')
  if [[ "$WIFI_STATUS" != "active" ]]; then
    echo 'Not connected'
  else
    WIFI_NAME=$(ifconfig  iwx0 | sed -En 's/.*join (.*) chan.*/\1/p')
    echo "${WIFI_NAME//\"/}"
  fi
  sleep 60
done
