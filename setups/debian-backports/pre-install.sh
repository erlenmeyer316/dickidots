#!/usr/bin/env bash

set -euo pipefail

check_backports() {
  if grep -q "deb*backports" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "[debian-backports] backports is already enabled on your system. Skipping."
    exit 0
  fi
}

get_debian_version() {
  if [ -f /etc/os-release ]; then
    . "/etc/os-release"
    echo "$VERSION_CODENAME"
  else
    echo "[debian-backports] Unable to determine Debian version. Aborting."
    exit 1
  fi
}

enable_backports() {
  local version=$(get_debian_version)
  echo "deb https://deb.debian.org/debian ${version}-backports main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/backports.list
  sudo apt update
  echo "[debian-backports] backports repository has been enabled on your system!"
}

check_backports
enable_backports
