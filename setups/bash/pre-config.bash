#!/usr/bin/env bash

set -euo pipefail

#if [ ! -d "$HOME/.local/bin" ]; then
#  echo "[setup] creating $HOME/.local/bin"
#  mkdir -p "$HOME/.local/bin"
#fi

if [ -f "$HOME/.profile" ]; then
  echo "[setup] backing up ${HOME}/.profile"
  mv "$HOME/.profile" "$HOME/.profile.bak"
fi

if [ -f "$HOME/.bashrc" ]; then
  echo "[setup] backing up ${HOME}/.bashrc"
  mv "$HOME/.bashrc" "$HOME/.bashrc_bak"
fi

if [ -f "$HOME/.bash_logout" ]; then
  echo "[setup] backing up ${HOME}/.bash_logout"
  mv "$HOME/.bash_logout" "$HOME/.bash_logout.bak"
fi
