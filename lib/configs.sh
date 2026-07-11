#!/usr/bin/env bash
# lib/configs.sh

readonly CONFIG_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/configs}"

# =========================================================
# New
# =========================================================

new_config() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local NEW_CONFIG_NAME="${1}"
  local NEW_CONFIG_PATH="${CONFIGS_DIR}/${NEW_CONFIG_NAME}"

  # create config directory
  if dir_exists "$NEW_CONFIG_PATH"; then
    print_always "A config named ${NEW_CONFIG_PATH} already exists."
    print_msg "Using existing config."
    print_always ""
  else
    dir_create "${NEW_CONFIG_PATH}"
  fi

  # create empty bash profile structure
  if ! file_exists "${NEW_PROFILE_PATH}/${SETUPS_PKGLIST}"; then
    print_always "Create ${SETUPS_PKGLIST} for ${NEW_PROFILE_NAME}?"
    read -r -p "[n/Y]: "
    if [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "" ]]; then
      print_msg "Creating ${NEW_PROFILE_PATH}/${SETUPS_PKGLIST}"
      touch "${NEW_PROFILE_PATH}/${SETUPS_PKGLIST}"
    fi
  else
    print_msg "${NEW_PROFILE_PATH}/${SETUPS_PKGLIST} exists."
    print_msg "Skipping..."
  fi
}
