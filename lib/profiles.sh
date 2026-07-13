#!/usr/bin/env bash

PROFILE_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"
mapfile -t ALL_PROFILES < <(ls "${PROFILE_DIR}")

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

list_profiles() {
  print_always "Available profiles:"
  printf "  %s\n" "${ALL_PROFILES[@]}"
}

list_profile_configs() {
  print_always "Not implemented"
}

list_profile_setups() {
  print_always "Not implemented"
}

list_profile_installs() {
  print_always "Not implemented"
}

get_profile_dependencies() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No profile given."
    exit 1
  fi

  if [[ -z $2 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No array given."
    exit 1
  fi

  local PROFILE_NAME="${1}"
  local PROFILE_PATH="${PROFILE_DIR}/${PROFILE_NAME}"
  local PROFILE_DEPLIST="${NEW_PROFILE_PATH}/profiles.deplist"
  local -n PROFILE_DEPS=$2

  if ! dir_exists "${PROFILE_PATH}"; then
    print_always "Error: profile ${PROFILE_NAME} doesn't exist."
    exit 1
  fi

  if file_exists "PROFILE_DEPLIST"; then
    while read -r profile; do
      local add_dep=1
      for i in "${PROFILE_DEPS[@]}"; do
        if [ "$i" == "$profile" ]; then
          add_dep=0
        fi
      done
      if [ $add_dep -eq 1 ]; then
        PROFILE_DEPS+=("${profile}")
        get_profile_dependencies "$profile" PROFILE_DEPS
      fi
    done <"$PROFILE_DEPLIST"
  fi
}
