#!/usr/bin/env bash

pm="pacman"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] sudo pacman -Sy"
  else
    sudo pacman -Sy
  fi
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] sudo pacman -S --noconfirm ${pkgs_in[*]}"
  else
    sudo pacman -S --noconfirm ${pkgs_in[*]}
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] sudo pacman -R --noconfirm ${pkgs_in[*]}"
  else
    sudo pacman -R --noconfirm ${pkgs_in[*]}
  fi
}

pkg_is_installed() {
  pacman -Qi "$1" &>/dev/null
}

pkg_exists() {
  pacman -Si "$1" &>/dev/null
}