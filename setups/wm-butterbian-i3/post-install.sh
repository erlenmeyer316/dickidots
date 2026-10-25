#!/usr/bin/env bash

set -euo pipefail

#exec "./scripts/install-ly.sh"
bash "./scripts/install-nerdfonts.sh"
bash "./scripts/install-theme.sh"
bash "./scripts/download-wallpapers.sh"
bash "./scripts/kitty/install_kitty.sh"
bash "./scripts/install-bluetooth-support.sh"
bash "./scripts/install-printing-support.sh"
