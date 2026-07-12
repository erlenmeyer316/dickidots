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
  local NEW_FILES=(
    "${NEW_PROFILE_PATH}/setups.pkglist"
    "${NEW_PROFILE_PATH}/configs.pkglist"
    "${NEW_PROFILE_PATH}/profiles.deplist"
    "${NEW_PROFILE_PATH}/${_DISTRO}-${_VERSION}.binlist"
  )

  if dir_exists "$NEW_PROFILE_PATH"; then
    print_always "Error: A profile named ${NEW_PROFILE_PATH} already exists."
    exit 1
  fi

  dir_create "${NEW_PROFILE_PATH}"

  for file in "${!NEW_FILES[@]}"; do
    file_create "${NEW_FILES[$file]}"
  done
}
