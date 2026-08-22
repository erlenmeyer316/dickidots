#!/usr/bin/env bash

set -euo pipefail

if [ ! -L "$HOME/.profile" ] && [ ! -f "$HOME/.profile.bak" ]; then
  echo "[setup] backing up ${HOME}/.profile"
  mv "$HOME/.profile" "$HOME/.profile.bak"
fi

if [ ! -L "$HOME/.bashrc" ] && [ ! -f "$HOME/.bashrc_bak" ]; then
  echo "[setup] backing up ${HOME}/.bashrc"
  mv "$HOME/.bashrc" "$HOME/.bashrc_bak"
fi

if [ ! -L "$HOME/.bash_logout" ] && [ ! -f "$HOME/.bash_logout.bak" ]; then
  echo "[setup] backing up ${HOME}/.bash_logout"
  mv "$HOME/.bash_logout" "$HOME/.bash_logout.bak"
fi
