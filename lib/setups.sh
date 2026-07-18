#!/usr/bin/env bash

SETUP_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/setups}"
mapfile -t ALL_SETUPS < <(ls "${SETUP_DIR}")
# =========================================================
# New
# =========================================================

new_setup() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local NEW_SETUP_NAME="${1}"
  local NEW_SETUP_PATH="${SETUP_DIR}/${NEW_SETUP_NAME}"
  local NEW_FILES=(
    "${NEW_SETUP_PATH}/pre-apply.bash"
    "${NEW_SETUP_PATH}/post-apply.bash"
    "${NEW_SETUP_PATH}/pre-config.bash"
    "${NEW_SETUP_PATH}/post-config.bash"
    "${NEW_SETUP_PATH}/setup.bash"
    "${NEW_SETUP_PATH}/pre-install.bash"
    "${NEW_SETUP_PATH}/post-install.bash"
  )

  if dir_exists "$NEW_SETUP_PATH"; then
    print_always "Error: A setup named ${NEW_SETUP_NAME} already exists."
    exit 1
  fi

  dir_create "${NEW_SETUP_PATH}"

  for file in "${!NEW_FILES[@]}"; do
    file_create "${NEW_FILES[$file]}"
  done

}

list_setups() {
  print_always "Available setups:"
  printf "  %s\n" "${ALL_SETUPS[@]}"
}
