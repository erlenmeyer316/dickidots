#!/usr/bin/env bash

#readonly SCRIPT_DIR="$(cd "$(dirname "${BASHSOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly PROFILE_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"
readonly SETUPS_PKGLIST="setups.pkglist"
readonly CONFIGS_PKGLIST="configs.pkglist"
readonly PROFILE_DEPS_PKGLIST="profiles.deplist"
readonly INSTALL_DEPS_PKGLIST="${_DISTRO}-${_VERSION}.binlist"

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

  # create profile directory
  if dir_exists "$NEW_PROFILE_PATH"; then
    print_always "A profile named ${NEW_PROFILE_PATH} already exists."
    print_msg "Using existing profile."
    print_always ""
  else
    mkdir -p "${NEW_PROFILE_PATH}"
  fi

  # create empty setup package list
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

  # create empty configs package list
  if ! file_exists "${NEW_PROFILE_PATH}/${CONFIGS_PKGLIST}"; then
    print_always "Create ${CONFIGS_PKGLIST} for ${NEW_PROFILE_NAME}?"
    read -r -p "[n/Y]: "
    if [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "" ]]; then
      touch "${NEW_PROFILE_PATH}/${CONFIGS_PKGLIST}"
    fi
  else
    print_msg "${NEW_PROFILE_PATH}/${CONFIGS_PKGLIST} exists."
    print_msg "Skipping..."
  fi

  # create empty profile dependency package list
  if ! file_exists "${NEW_PROFILE_PATH}/${PROFILE_DEPS_PKGLIST}"; then
    print_always "Create ${PROFILE_DEPS_PKGLIST} for ${NEW_PROFILE_NAME}?"
    read -r -p "[n/Y]: "
    if [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "" ]]; then
      touch "${NEW_PROFILE_PATH}/${PROFILE_DEPS_PKGLIST}"
    fi
  else
    print_msg "${NEW_PROFILE_PATH}/${PROFILE_DEPS_PKGLIST} exists."
    print_msg "Skipping..."
  fi

  # create empty install dependency package list
  if ! file_exists "${NEW_PROFILE_PATH}/${INSTALL_DEPS_PKGLIST}"; then
    print_always "Create ${INSTALL_DEPS_PKGLIST} for ${NEW_PROFILE_NAME}?"
    read -r -p "[n/Y]: "
    if [[ "$REPLY" == "y" ]] || [[ "$REPLY" == "" ]]; then
      touch "${NEW_PROFILE_PATH}/${INSTALL_DEPS_PKGLIST}"
    fi
  else
    print_msg "${NEW_PROFILE_PATH}/${INSTALL_DEPS_PKGLIST} exists."
    print_msg "Skipping..."
  fi
}
