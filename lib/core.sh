#!/usr/bin/env bash

readonly _SCRIPT_DIR="$(cd "$(dirname "${BASHSOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Utility functions

command_exists() { command -v "$1" >/dev/null 2>&1; }

file_exists() { [[ -f "$1" ]]; }

dir_exists() { [[ -d "$1" ]]; }

print_msg() { [[ "$_QUIET" -eq 0 ]] && printf "%s\n" "$1"; }

print_always() { printf "%s\n" "$1"; }

file_list_contents() {
  file_exists "$1" && cat -n "$1"
}

file_create() {
  if file_exists "${1}"; then
    print_always "Error: ${1} already exist."
    return 1
  fi
  touch "${1}"
  return 0
}

dir_create() {
  if dir_exists "${1}"; then
    print_always "Error: ${1} already exist."
    return 1
  fi
  mkdir -p "${1}"
  return 1
}

array_contains_element() {
  local e match="$1"
  shift
  for e; do
    [[ "$e" == "$match" ]] && return 0
  done
  return 1
}

case "$OSTYPE" in
  linux*) _OS="Linux" ;;
  darwin*) _OS="macOS" ;;
  msys*) _OS="Windows" ;;
  cygwin*) _OS="Cygwin" ;;
  solaris*) _OS="Solaris" ;;
  bsd*) _OS="BSD" ;;
  *) _OS="Unknown ($OSTYPE)" ;;
esac

if [ "$_OS" = "Linux" ]; then
  if [ -f /etc/os-release ]; then
    # Load variables from /etc/os-release
    . /etc/os-release
    _DISTRO=$ID
    _VERSION=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # Fallback to lsb_release if /etc/os-release is missing
    _DISTRO=$(lsb_release -si)
    _VERSION=$(lsb_release -sr)
  else
    # Basic fallback for older or minimal systems
    _DISTRO=$(uname -s)
    _VERSION=$(uname -r)
  fi
fi

readonly _LIB_DIR="${_SCRIPT_DIR}/lib"
readonly _PROFILE_DIR="${DOTFILES_PROFILE_DIR:-${_SCRIPT_DIR}/profiles}"
readonly _CONFIG_DIR="${DOTFILES_CONFIG_DIR:-${_SCRIPT_DIR}/configs}"
readonly _SETUP_DIR="${DOTFILES_SETUP_DIR:-${_SCRIPT_DIR}/setups}"
