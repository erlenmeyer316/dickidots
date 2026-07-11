#!/usr/bin/env bash

PROFILE_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"

# =========================================================
# New
# =========================================================

new_profile() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local NEW_PROFILE_NAME="${1}"
  local NEW_PROFILE_PATH="${PROFILE_DIR}/${NEW_PROFILE_NAME}"

  # create profile directory
  if dir_exists "$NEW_PROFILE_PATH"; then
    print_always "Error: A profile named ${NEW_PROFILE_PATH} already exists."
    exit 1
  else
    dir_create "${NEW_PROFILE_PATH}"
  fi

  file_create "${NEW_PROFILE_PATH}/setups.pkglist"
  file_create "${NEW_PROFILE_PATH}/configs.pkglist"
  file_create "${NEW_PROFILE_PATH}/profiles.deplist"
  file_create "${NEW_PROFILE_PATH}/${_DISTRO}-${_VERSION}.binlist"
}
