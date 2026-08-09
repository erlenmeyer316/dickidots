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

apply_installs() {
  local -n installs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  local sorted=()
  sort_array installs_in sorted

  for driver in "${_SCRIPT_DIR}"/lib/drivers/*; do
    source "$driver"
    install sorted "$dry_run" "$force" "$quiet"
  done
}

remove_installs() {
  local -n installs_in=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  local sorted=()
  sort_array installs_in sorted

  for driver in "${_SCRIPT_DIR}"/lib/drivers/*; do
    source "$driver"
    uninstall sorted "$dry_run" "$force" "$quiet"
  done
}

install() {
  local -n pkglist=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ ${#pkglist[@]} -eq 0 ]]; then
    print_msg "[install][$pm] Nothing to install." "$quiet"
    return 0
  fi

  print_msg "[$pm] Refreshing package index..." "$quiet"
  pkg_update_repos "$dry_run" "$force" "$quiet"

  local available=()
  local to_install=()

  for pkg in "${pkglist[@]}"; do
    IFS=: read -r key bin <<<"$pkg"
    unset IFS

    if [ "$key" != "$pm" ]; then
      print_msg "not valid package" "$quiet"
      continue
    fi

    if ! pkg_is_installed "$bin"; then
      print_msg "[${pm}] Marking ${bin} for install" "$quiet"
      to_install+=("$bin")
    else
      print_msg "[${pm}] ${bin} already installed" "$quiet"
    fi

    if pkg_exists "$bin"; then
      available+=("$bin")
    else
      print_always "Warning: [${pm}] '${bin}' not found in repository — skipping."
    fi
  done

  for bin in "${to_install[@]}"; do
    if pkg_exists "$bin"; then
      available+=("$bin")
    else
      print_always "Warning: [${pm}] '${bin}' not found in repository — skipping."
    fi
  done

  pkg_install available "$dry_run" "$force" "$quiet"

}

remove() {
  local -n pkglist=$1
  local dry_run=$2
  local force=$3
  local quiet=$4

  if [[ ${#pkglist[@]} -eq 0 ]]; then
    print_msg "[install][$pm] Nothing to remove." "$quiet"
    return 0
  fi

  for pkg in "${pkglist[@]}"; do
    IFS=: read -r key bin <<<"$pkg"
    unset IFS

    if [ "$key" != "$pm" ]; then
      continue
    fi

    local to_remove=()
    if ! pkg_is_installed "$pkg"; then
      print_msg "  [${pm}] Queuing ${pkg}" "$quiet"
      to_remove+=("$pkg")
    fi

    print_msg "[${pm}] Removing: ${to_remove[*]}" "$quiet"
    pkg_install "${to_remove[@]}"
  done

}
