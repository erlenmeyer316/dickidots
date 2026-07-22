#!/usr/bin/env bash

pm="apt"

pkg_update_repos() {
  sudo apt-get update
}

pkg_install() {
  sudo apt-get install -y "$@"
}

pkg_remove() {
  sudo apt-get remove -y "$@"
}

pkg_is_installed() {
  dpkg -s "$1" &>/dev/null
}

pkg_exists() {
  apt-cache show "$1" &>/dev/null
}

install() {
  local -n pkglist=$1

  if [[ ${#pkglist[@]} -eq 0 ]]; then
    print_msg "[$pm] Nothing to install."
    return 0
  fi

  print_msg "[$pm] Refreshing package index..."
  pkg_update_repos

  for pkg in "${pkglist[@]}"; do
    IFS=: read -r key bin <<<"$pkg"
    unset IFS

    if [ "$key" != "$pm" ]; then
      continue
    fi

    local available=()
    if pkg_exists "$bin"; then
      available+=("$bin")
    else
      print_always "Warning: [${pm}] '${bin}' not found in repository — skipping."
    fi
    [[ ${#available[@]} -eq 0 ]] && continue

    local to_install=()
    for pkg in "${available[@]}"; do
      if ! pkg_is_installed "$pkg"; then
        print_msg "  [${pm}] Queuing ${pkg}"
        to_install+=("$pkg")
      fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
      print_msg "[${pm}] All packages already installed."
      continue
    fi

    print_msg "[${pm}] Installing: ${to_install[*]}"
    pkg_install "${to_install[@]}"
  done
}
