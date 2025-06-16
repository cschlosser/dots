#!/bin/bash

for dir in bat fzf ripgrep fish nvim; do
  ln -s "~/dots/$dir" ~/.config/
done
