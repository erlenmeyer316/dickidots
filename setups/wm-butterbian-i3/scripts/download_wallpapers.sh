
#!/usr/bin/env bash

set -euo pipefail

echo "Downloading wallpaper directory..."

if [ ! -d "$CONFIG_DIR/wallpaper/butterbian" ]; then
  git clone --depth 1 --progress https://github.com/drewgrif/wallpapers.git "$CONFIG_DIR/wallpaper/butterbian" || die "Failed to clone wallpapers"
  rm -rf "$CONFIG_DIR/wallpaper/butterbian/.git"
else
  echo "Wallpaper directory already exists, skipping..."
fi

