#!/usr/bin/env bash

PROFILE_DIR="${DOTfiles_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"
mapfile -t ALL_PROFILES < <(ls "${PROFILE_DIR}")

# =========================================================
# New
# =========================================================

new_profile() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No name given."
    exit 1
  fi

  local profile="${1}"
  local profile_path="${PROFILE_DIR}/${profile}"
  local files=(
    "${profile_path}/setups.pkglist"
    "${profile_path}/configs.pkglist"
    "${profile_path}/profiles.deplist"
    "${profile_path}/${_DISTRO}-${_VERSION}.binlist"
  )

  if dir_exists "$profile_path"; then
    print_always "Error: A profile named ${profile_path} already exists."
    exit 1
  fi

  dir_create "${profile_path}"

  for file in "${!files[@]}"; do
    file_create "${files[$file]}"
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

resolve_profiles() {
  if [[ -z $1 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No profile given."
    exit 1
  fi

  if [[ -z $2 ]]; then
    print_always "Error:${FUNCNAME[0]}}:Missing parameter: No array given."
    exit 1
  fi

  local profile="${1}"
  local profile_path="${PROFILE_DIR}/${profile}"
  local deplist="${profile_path}/profiles.deplist"
  local -n resolved_profiles=$2

  if ! dir_exists "${profile_path}"; then
    print_always "Error: profile ${profile} doesn't exist."
    exit 1
  fi

  if file_exists "${deplist}"; then
    while IFS= read -r dep; do
      local dep_added=0
      for p in "${resolved_profiles[@]}"; do
        if [[ "$p" == "$dep" ]]; then
          dep_added=1
          break
        fi
      done
      if [[ $dep_added -eq 0 ]]; then
        resolved_profiles+=("$dep")
        resolve_profiles "$dep" "$2"
      fi
    done <"${deplist}"
  fi
}
