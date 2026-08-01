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
    "${NEW_SETUP_PATH}/pre-apply.bash"
    "${NEW_SETUP_PATH}/post-apply.bash"
    "${NEW_SETUP_PATH}/pre-config.bash"
    "${NEW_SETUP_PATH}/post-config.bash"
    "${new_setup_path}/pre-install.bash"
    "${new_setup_path}/post-install.bash"
    "${new_setup_path}/pre-remove.bash"
    "${new_setup_path}/post-remove.bash"
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

execute_pre_apply() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre_apply.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_pre_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/${setups_in[$setup]}/pre_config.bash"
    ! file_exists "${setup_script}" || return 0
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

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre_install.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_pre_remove() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre_remove.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_pre_remove_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre_remove.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_pre_remove_configs() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/pre_remove.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_post_apply() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post_apply.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_post_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post_config.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_post_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post_install.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}

execute_post_remove() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post_remove.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}
execute_post_remove_install() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post_remove_install.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}
execute_post_remove_config() {
  local -n setups_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  for setup in "${!setups_in[@]}"; do
    local setup_script="${SETUP_DIR}/$setup/post_remove_config.bash"
    file_exists "${setup_script}" || return 0
    if [[ "$dry_run" -eq 1 ]]; then
      print_always "[setup] bash ${setup_script}"
    else
      bash "${setup_script}"
    fi
  done
}
