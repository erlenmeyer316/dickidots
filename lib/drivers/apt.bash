#!/usr/bin/env bash

pm="apt"

pkg_update_repos() {
  sudo apt-get update
}

pkg_install() {
  sudo apt-get install -y "$@"
}

pkg_remove() {
  sudo apt-get remove -y "$@"
}

pkg_is_installed() {
  dpkg -s "$1" &>/dev/null
}

pkg_exists() {
  apt-cache show "$1" &>/dev/null
}
