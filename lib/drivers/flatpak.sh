#!/usr/bin/env bash

pm="flatpak"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] flatpak update --appstream -y"
  else
    flatpak update --appstream -y
  fi
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] flatpak install -y ${pkgs_in[*]}"
  else
    flatpak install -y ${pkgs_in[*]}
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] flatpak uninstall -y ${pkgs_in[*]}"
  else
    flatpak uninstall -y ${pkgs_in[*]}
  fi
}

pkg_is_installed() {
  flatpak info "$1" &>/dev/null
}

pkg_exists() {
  flatpak remote-info flathub "$1" &>/dev/null
}