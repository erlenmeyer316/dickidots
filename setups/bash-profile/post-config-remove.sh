#!/usr/bin/env bash

set -euo pipefail

if [ -f "$HOME/.profile.bak" ]; then
  echo "[setup] restoring ${HOME}/.profile"
  mv "$HOME/.profile.bak" "$HOME/.profile"
fi

if [ -f "$HOME/.bashrc.bak" ]; then
  echo "[setup] restoring ${HOME}/.bashrc"
  mv "$HOME/.bashrc.bak" "$HOME/.bashrc"
fi

if [ -f "$HOME/.bash_logout.bak" ]; then
  echo "[setup] restoring ${HOME}/.bash_logout"
  mv "$HOME/.bash_logout.bak" "$HOME/.bash_logout"
fi
