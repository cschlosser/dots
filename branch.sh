#!/usr/bin/env fish

git checkout $argv[1]
or exit 1

git submodule foreach "git checkout $argv[1]"
or exit 1
