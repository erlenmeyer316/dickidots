#!/usr/bin/env bash
pm="flatpak"

pkg_update_repos() {
  flatpak update --appstream -y 2>/dev/null || true
}

pkg_install() {
  flatpak install -y "$@"
}

pkg_remove() {
  flatpak uninstall -y "$@"
}

pkg_is_installed() {
  flatpak info "$1" &>/dev/null
}

pkg_exists() {
  flatpak search --columns=application "$1" 2>/dev/null |
    grep -qxF "$1"
}
