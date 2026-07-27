#!/usr/bin/env bash

readonly _SCRIPT_DIR="$(cd "$(dirname "${BASHSOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Utility functions

command_exists() { command -v "$1" >/dev/null 2>&1; }

file_exists() { [[ -f "$1" ]]; }

dir_exists() { [[ -d "$1" ]]; }

print_msg() { [[ "${2}" -eq 0 ]] && printf "%s\n" "$1"; }

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

array_contains() {
  local needle="$1"
  shift
  local x
  for x in "$@"; do
    [[ "$x" == "$needle" ]] && return 0
  done
  return 1
}

sort_array() {
  local -n _src="$1"
  local -n _dst="$2"
  local flags=${3:--}

  if [[ "$flags" == "-" ]]; then
    mapfile -t _dst < <(printf '%s\n' "${_src[@]}" | sort)
  else
    mapfile -t _dst < <(printf '%s\n' "${_src[@]}" | sort "$flags")
  fi
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
