#!/usr/bin/env bash

while true; do
  sysctl hw.sensors.ksmn0.temp | cut -d'=' -f2 | cut -d'.' -f1
  sleep 1
done
