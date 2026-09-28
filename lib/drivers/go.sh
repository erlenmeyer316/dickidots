#!/usr/bin/env bash

pm="go"

pkg_update_repos() {
  local dry_run=$1
  local force=$2
  local quiet=$3

  if [[ $dry_run -eq 1 ]]; then
    print_msg "[${pm}] no-op (go has no repo update step)"
  fi
  return 0
}

pkg_install() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for pkg in "${pkgs_in[@]}"; do
    if [[ $dry_run -eq 1 ]]; then
      print_msg "[${pm}] go install ${pkg}@latest"
    else
      go install "${pkg}@latest"
    fi
  done
}

pkg_uninstall() {
  local -n pkgs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  local gobin="${GOBIN:-$(go env GOPATH)/bin}"

  for pkg in "${pkgs_in[@]}"; do
    if [[ $dry_run -eq 1 ]]; then
      print_msg "[${pm}] rm ${gobin}/$(basename "$pkg")"
    else
      rm -f "${gobin}/$(basename "$pkg")"
    fi
  done
}

pkg_is_installed() {
  local gobin="${GOBIN:-$(go env GOPATH)/bin}"
  [[ -x "${gobin}/$(basename "$1")" ]]
}

pkg_exists() {
  go list -m "$1@latest" &>/dev/null
}