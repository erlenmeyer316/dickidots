#!/usr/bin/env bash

SETUP_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/setups}"
mapfile -t ALL_SETUPS < <(ls "${SETUP_DIR}")

new_setup() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local NEW_SETUP_NAME="${1}"
  local NEW_SETUP_PATH="${SETUP_DIR}/${NEW_SETUP_NAME}"
  local NEW_FILES=(
    "${NEW_SETUP_PATH}/post-apply.sh"
    "${NEW_SETUP_PATH}/post-config.sh"
    "${NEW_SETUP_PATH}/post-install.sh"
    "${NEW_SETUP_PATH}/post-remove.sh"
    "${NEW_SETUP_PATH}/post-remove-install.sh"
    "${NEW_SETUP_PATH}/post-remove-config.sh"
    "${NEW_SETUP_PATH}/pre-apply.sh"
    "${NEW_SETUP_PATH}/pre-config.sh"
    "${NEW_SETUP_PATH}/pre-install.sh"
    "${NEW_SETUP_PATH}/pre-remove.sh"
    "${NEW_SETUP_PATH}/pre-remove-install.sh"
    "${NEW_SETUP_PATH}/pre-remove-configs.sh"
  )

  local basescript=( '#!/usr/bin/env bash' 'set -euo pipefail' 'echo "Edit $(dirname "$0")/$(basename "$0") or delete if not needed"')

  if dir_exists "$NEW_SETUP_PATH"; then
    print_always "Error: A setup named ${NEW_SETUP_NAME} already exists."
    exit 1
  fi

  dir_create "${NEW_SETUP_PATH}"

  for file in "${!NEW_FILES[@]}"; do
    file_create "${NEW_FILES[$file]}"
    printf '%s\n' "${basescript[@]}" >> "${NEW_FILES[$file]}"
    chmod +x "${NEW_FILES[$file]}"
  done

}

list_setups() {
  print_always "Available setups:"
  printf "  %s\n" "${ALL_SETUPS[@]}"
}

execute_pre_apply() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre-apply.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_pre_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/${setup}/pre-config.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_pre_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/${setup}/pre-install.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_pre_remove() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre-remove.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_pre_remove_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre-remove.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_pre_remove_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre-remove.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_post_apply() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post-apply.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_post_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post-config.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_post_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post-install.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}

execute_post_remove() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post-remove.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}
execute_post_remove_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post-remove-install.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}
execute_post_remove_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post-remove-config.sh"
    if ! file_exists "${setup_script}"; then
      continue
    fi
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "$setup_script"
    fi
  done
}
