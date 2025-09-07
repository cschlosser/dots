#!/usr/bin/env bash

while true; do
  WIFI_STATUS=$(wpa_cli status | grep wpa_state | awk -F'=' '{print $2}')
  if [[ "$WIFI_STATUS" == "DISCONNECTED" ]]; then
    echo 'Not connected'
  else
    WIFI_NAME=$(wpa_cli status | grep ssid | awk -F'=' '{print $2}')
    echo "$WIFI_NAME"
  fi
  sleep 60
done
