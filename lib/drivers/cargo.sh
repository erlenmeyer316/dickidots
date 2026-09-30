#!/usr/bin/env bash

pm="cargo"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] no-op (cargo has no repo update step)"
  fi
  return 0
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] cargo install ${pkgs_in[*]}"
  else
    cargo install ${pkgs_in[*]}
  fi
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] cargo uninstall ${pkgs_in[*]}"
  else
    cargo uninstall ${pkgs_in[*]}
  fi
}

pkg_is_installed() {
  cargo install --list | grep -q "^$1 v"
}

pkg_exists() {
  curl -sf "https://crates.io/api/v1/crates/$1" &>/dev/null
}