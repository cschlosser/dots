#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
pushd $SCRIPT_DIR

mkdir -p ~/.config
pushd ~/.config
for dir in bat fish fzf herbstluftwm kitty nvim polybar ripgrep; do
  ln -s "${SCRIPT_DIR}/${dir}" .
done
popd

pushd ~
for f in $(find $SCRIPT_DIR -type f -name 'dot.*'); do
  file="$(basename $f)"
  ln -s "${SCRIPT_DIR}/${file}" "${file/dot/}"
done
popd

popd
