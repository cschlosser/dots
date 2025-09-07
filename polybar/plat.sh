#!/usr/bin/env bash

PLAT=$(uname)
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

"${SCRIPT_DIR}/${PLAT}-${1}.sh"
