#!/usr/bin/env bash
# lib/configs.sh

readonly CONFIG_DIR="${DOTFILES_CONFIG:-${_SCRIPT_DIR}/configs}"

# =========================================================
# New
# =========================================================

new_config() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local NEW_CONFIG_NAME="${1}"
  local NEW_CONFIG_PATH="${CONFIG_DIR}/${NEW_CONFIG_NAME}"
  local BASH_DIR="${NEW_CONFIG_PATH}/.config/bash"
  local BASH_ALIAS_DIR="${BASH_DIR}/aliases.d"
  local BASH_COMPLETION_DIR="${BASH_DIR}/completions.d"
  local BASH_CONFIG_DIR="${BASH_DIR}/config.d"
  local BASH_FUNCTION_DIR="${BASH_DIR}/functions.d"

  # create config directory
  if dir_exists "${NEW_CONFIG_PATH}"; then
    print_always "Error: A config named ${NEW_CONFIG_PATH} already exists."
    exit 0
    #print_msg "Using existing config."
    #print_always ""
  else
    dir_create "${NEW_CONFIG_PATH}"
  fi

  # create empty bash profile structure
  print_always "Create bash config struture for ${NEW_CONFIG_NAME}?"
  read -r -p "[y/N]: "
  if [[ "$REPLY" == "n" ]] || [[ "$REPLY" == "" ]]; then
    exit 1
  fi

  dir_create "${BASH_ALIAS_DIR}"
  dir_create "${BASH_COMPLETION_DIR}"
  dir_create "${BASH_CONFIG_DIR}"
  dir_create "${BASH_FUNCTION_DIR}"

  file_create "${BASH_ALIAS_DIR}/${NEW_CONFIG_NAME}.bash"
  file_create "${BASH_COMPLETION_DIR}/${NEW_CONFIG_NAME}.bash"
  file_create "${BASH_CONFIG_DIR}/${NEW_CONFIG_NAME}.bash"
  file_create "${BASH_FUNCTION_DIR}/${NEW_CONFIG_NAME}.bash"
}
