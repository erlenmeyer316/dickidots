#!/usr/bin/env bash

set -euo pipefail

exec "./scripts/install_ly.sh"
exec "./scripts/install_nerdfonts.sh"
exec "./scripts/install_theme.sh"
exec "./scripts/download_wallpapers.sh"
exec "./scripts/kitty/install_kitty.sh"
