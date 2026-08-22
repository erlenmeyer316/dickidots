#!/usr/bin/env bash

set -euo pipefail

if [ ! -d "$HOME/.local/bin" ]; then
  echo "[setup] creating $HOME/.local/bin"
  mkdir -p "$HOME/.local/bin"
fi
