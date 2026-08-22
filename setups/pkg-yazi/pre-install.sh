#!/usr/bin/env bash

set -euo pipefail

# skip if already installed
command -v yazi >/dev/null 2>&1 && echo "[yazi] is already installed. Skipping." && exit 0

if ! command -v git &>/dev/null; then
  echo "[yazi] requires curl"
  exit 0
fi

if ! command -v gpg &>/dev/null; then
  echo "[yazi] requires gpg"
  exit 0
fi

if [ ! -f "/usr/share/keyrings/yazi-keyring.gpg" ]; then
  echo "[setup] adding yazi repository gpg key"
  curl -fsSl https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg > /dev/null
fi

if [ ! -f "/etc/apt/sources.list.d/yazi.list" ]; then
  echo "[setup] adding yazi repository"
  echo "deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds stable main" | sudo tee /etc/apt/sources.list.d/yazi.list
fi
