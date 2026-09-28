#!/usr/bin/env bash

pm="pipx"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] no-op (pipx has no repo update step)"
  fi
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
    for pkg in "${pkgs_in[@]}"; do
      pipx install "$pkg"
    done
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
    for pkg in "${pkgs_in[@]}"; do
      pipx uninstall "$pkg"
    done
  fi
}

pkg_is_installed() {
  pipx list --short 2>/dev/null | awk '{print $1}' | grep -qx "$1"
}

pkg_exists() {
  pip index versions "$1" &>/dev/null
}