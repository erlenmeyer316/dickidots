#!/usr/bin/env bash

# =========================================================
# New
# =========================================================

new_install() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No profile given."
    exit 1
  fi

  local PROFILE_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"
  local EXISTING_PROFILE_NAME="${1}"
  local EXISTING_PROFILE_PATH="${PROFILE_DIR}/${EXISTING_PROFILE_NAME}"
  local NEW_INSTALL_FILE="${EXISTING_PROFILE_PATH}/${_DISTRO}-${_VERSION}.binlist"

  if ! dir_exists "${EXISTING_PROFILE_PATH}"; then
    print_always "Error: No profile named ${EXISTING_PROFILE_NAME} exists."
    exit 1
  fi

  file_create "${NEW_INSTALL_FILE}"
}
