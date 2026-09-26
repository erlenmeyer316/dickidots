#!/usr/bin/env bash

pm="pipx"

pkg_update_repos() {
  return 0
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] pipx install ${pkgs_in[*]}"
  else
    pipx install "${pkgs_in[*]}"
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] pipx uninstall ${pkgs_in[*]}"
  else
    pipx uninstall "${pkgs_in[*]}"
  fi
}

pkg_is_installed() {
  pip index versions "$1" &>/dev/null
}

pkg_exists() {

  if pipx list --short | grep -q "^${1} "; then
    return 0
  else
    return 1
  fi
}
