#!/usr/bin/env bash

kill $(pgrep -U $(whoami) 'polybar')
