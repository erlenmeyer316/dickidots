#!/usr/bin/env bash

readonly _SCRIPT_DIR="$(cd "$(dirname "${BASHSOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly _PROFILE_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"

# =========================================================
# New
# =========================================================

new_profile() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local path="${_PROFILE_DIR}/${1}"

  if dir_exists "$path"; then
    print_always "Error: A profile named ${1} already exists."
    print_always ""
    exit 1
  fi

  mkdir "${path}"
  touch "${path}/setups.pkglist"
  touch "${path}/stow.pkglist"
  touch "${path}/"
}
