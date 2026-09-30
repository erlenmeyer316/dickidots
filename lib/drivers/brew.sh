#!/usr/bin/env bash

pm="brew"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] brew update"
  else
    brew update
  fi
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] brew install ${pkgs_in[*]}"
  else
    brew install ${pkgs_in[*]}
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] brew uninstall ${pkgs_in[*]}"
  else
    brew uninstall ${pkgs_in[*]}
  fi
}

pkg_is_installed() {
  brew list --versions "$1" &>/dev/null
}

pkg_exists() {
  brew info "$1" &>/dev/null
}