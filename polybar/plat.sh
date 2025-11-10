#!/usr/bin/env bash

PLAT=$(uname)
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

SCRIPT="${SCRIPT_DIR}/${PLAT}-${1}.sh"
if [ -f "${SCRIPT}" ]; then
  "${SCRIPT}"
fi
