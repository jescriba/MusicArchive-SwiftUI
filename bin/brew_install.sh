#!/bin/bash

if test -z "$HOMEBREW_NO_AUTO_UPDATE"; then
  brew update
fi
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

for dep in "$@"; do
  if brew ls --versions "$dep" >/dev/null; then
    brew outdated "$dep" || brew upgrade "$dep"
  else
    brew install "$dep"
  fi
done
