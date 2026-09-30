#!/usr/bin/env bash

pm="apk"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] apk update"
  else
    apk update
  fi
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] apk add ${pkgs_in[*]}"
  else
    apk add ${pkgs_in[*]}
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] apk del ${pkgs_in[*]}"
  else
    apk del ${pkgs_in[*]}
  fi
}

pkg_is_installed() {
  apk info -e "$1" &>/dev/null
}

pkg_exists() {
  apk info -a "$1" &>/dev/null
}