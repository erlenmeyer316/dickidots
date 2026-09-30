#!/usr/bin/env bash

pm="yay"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] yay -Sy"
  else
    yay -Sy
  fi
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] yay -S --noconfirm ${pkgs_in[*]}"
  else
    yay -S --noconfirm ${pkgs_in[*]}
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] yay -R --noconfirm ${pkgs_in[*]}"
  else
    yay -R --noconfirm ${pkgs_in[*]}
  fi
}

pkg_is_installed() {
  pacman -Qi "$1" &>/dev/null
}

pkg_exists() {
  yay -Si "$1" &>/dev/null
}