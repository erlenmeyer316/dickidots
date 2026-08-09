#!/usr/bin/env bash

pm="apt"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] sudo apt update"
  else
    sudo apt-get update
  fi
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] sudo apt install -y ${pkgs_in[*]}"
  else
    sudo apt-get install -y ${pkgs_in[*]}
  fi
}

pkg_remove() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  sudo apt-get remove -y "$@"
}

pkg_is_installed() {
  dpkg -s "$1" &>/dev/null
}

pkg_exists() {

  apt-cache show "$1" &>/dev/null
}
