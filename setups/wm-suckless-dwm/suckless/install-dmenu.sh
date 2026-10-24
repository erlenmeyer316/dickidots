#!/usr/bin/env bash

set -euo pipefail

# skip if already installed
command -v dmenu > /dev/null 2>&1 && echo "[dmenu] is already installed. Skipping." && exit 0

if ! command -v git &> /dev/null; then
    print_msg "[dmenu] requires curl"
    exit 0
fi

if ! command -v make >/dev/null 2>&1; then
    print_msg "[dmenu] requires unzip"
    exit 0
fi

ST_BUILD_DIR="/tmp//build/dmenu"
ST_GIT_REPO="https://github.com/erlenmeyer316/dmenu"

rm -rf "$ST_BUILD_DIR"
mkdir -p "$ST_BUILD_DIR"
git -C "$ST_BUILD_DIR" clone "$ST_GIT_REPO" .
make -C "$ST_BUILD_DIR"
sudo make -C "$ST_BUILD_DIR" install
