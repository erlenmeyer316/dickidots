#!/usr/bin/env bash

set -euo pipefail

readonly THIS_DIR="$(cd "$(dirname "${BASHSOURCE[0]}")" >/dev/null 2>&1 && pwd)"

#exec "./scripts/install-ly.sh"
bash "${THIS_DIR}/scripts/install-nerdfonts.sh"
bash "${THIS_DIR}/scripts/install-theme.sh"
bash "${THIS_DIR}/scripts/download-wallpapers.sh"
bash "${THIS_DIR}/scripts/kitty/install_kitty.sh"
bash "${THIS_DIR}/scripts/install-bluetooth-support.sh"
bash "${THIS_DIR}/scripts/install-printing-support.sh"
