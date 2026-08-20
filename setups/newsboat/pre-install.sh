#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "$HOME/.local/share/newsboat" ]; then
  echo "[setup] creating $HOME/.local/share/newsboat"
  mkdir -p "$HOME/.local/share/newsboat"
fi
