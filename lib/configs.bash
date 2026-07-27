#!/usr/bin/env bash
# lib/configs.sh

CONFIG_DIR="${DOTFILES_CONFIG:-${_SCRIPT_DIR}/configs}"

new_config() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local NEW_CONFIG_NAME="${1}"
  local NEW_CONFIG_PATH="${CONFIG_DIR}/${NEW_CONFIG_NAME}"
  local NEW_BASH_PATH="${NEW_CONFIG_PATH}/.config/bash"

  local NEW_DIRS=(
    "${NEW_BASH_PATH}/aliases.d"
    "${NEW_BASH_PATH}/completions.d"
    "${NEW_BASH_PATH}/config.d"
    "${NEW_BASH_PATH}/functions.d"
  )

  local NEW_FILES=(
    "${NEW_BASH_PATH}/aliases.d/${NEW_CONFIG_NAME}.bash"
    "${NEW_BASH_PATH}/completions.d/${NEW_CONFIG_NAME}.bash"
    "${NEW_BASH_PATH}/config.d/${NEW_CONFIG_NAME}.bash"
    "${NEW_BASH_PATH}/functions.d/${NEW_CONFIG_NAME}.bash"
  )

  if dir_exists "${NEW_CONFIG_PATH}"; then
    print_always "Error: A config named ${NEW_CONFIG_PATH} already exists."
    exit 1
  fi

  dir_create "${NEW_CONFIG_PATH}"

  print_always "Create bash config struture for ${NEW_CONFIG_NAME}?"
  read -r -p "[y/N]: "
  if [[ "$REPLY" == "n" ]] || [[ "$REPLY" == "" ]]; then
    exit 1
  fi

  for dir in "${!NEW_DIRS[@]}"; do
    dir_create "${NEW_DIRS[$dir]}"
  done

  for file in "${!NEW_FILES[@]}"; do
    file_create "${NEW_FILES[$file]}"
  done

}

list_configs() {
  mapfile -t ALL_CONFIGS < <(ls "${CONFIG_DIR}")
  print_always "Available configs:"
  printf "  %s\n" "${ALL_CONFIGS[@]}"
}

apply_configs() {
  local -n configs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for c in "${!configs_in[@]}"; do
    local CONFIG_NAME="${configs_in[$c]}"
    local CONFIG_PATH="${CONFIG_DIR}/${CONFIG_NAME}"
    if [[ $dry_run -eq 1 ]]; then
      print_always "[dry-run] applying config ${CONFIG_NAME}"
    else
      print_msg "[config]: applying ${configs_in[$c]}" "$quiet"
      if [[ "$force" -eq 1 ]]; then
        stow --adopt -d "${CONFIG_DIR}" -t ~ -R "${CONFIG_NAME}"
      else
        stow -d "${CONFIG_DIR}" -t ~ -R "${CONFIG_NAME}"
      fi
    fi

  done
}

remove_configs() {
  local -n configs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for c in "${!configs_in[@]}"; do
    local CONFIG_NAME="${configs_in[$c]}"
    local CONFIG_PATH="${CONFIG_DIR}/${CONFIG_NAME}"
    if [[ $dry_run -eq 1 ]]; then
      print_always "[dry-run] stow -d ${CONFIG_PATH} -t ~ -D ${CONFIG_NAME}"
    else
      print_msg "[config]: applying ${configs_in[$c]}" "$quiet"
      if [[ "$force" -eq 1 ]]; then
        stow --adopt -d "${CONFIG_DIR}" -t ~ -D "${CONFIG_NAME}"
      else
        stow -d "${CONFIG_DIR}" -t ~ -D "${CONFIG_NAME}"
      fi
    fi

  done
}
