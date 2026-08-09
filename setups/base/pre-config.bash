#!/usr/bin/env bash

set -euo pipefail

if [ ! -d "$HOME/.local/bin" ]; then
  echo "[setup] creating $HOME/.local/bin"
  mkdir -p "$HOME/.local/bin"
fi

if [ -f "$HOME/.profile" ]; then
  mv "$HOME/.profile" "$HOME/.profile.bak"
fi

if [ -f "$HOME/.bashrc" ]; then
  mv "$HOME/.bashrc" "$HOME/.bashrc_bak"
fi

if [ -f "$HOME/.bash_logout" ]; then
  mv "$HOME/.bash_logout" "$HOME/.bash_logout.bak"
fi
