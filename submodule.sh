#!/usr/bin/env fish

set -l updated
set -l msgs
for submodule in (git submodule | awk '{ print $2 }')
  set diff_msg (git diff --submodule "$submodule")
  if test -n "$diff_msg"
    set -a updated "$submodule"
    set -a msgs $diff_msg
  end
end

if test -n "$updated"
  git add $updated
  git commit -m "Updated submodules: $(string join ', ' $updated)" \
    -m "$(string collect -N $msgs)"
end
