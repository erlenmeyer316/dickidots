#!/usr/bin/env bash

shopt -s nullglob

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/core.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/profiles.sh"

debug() {
  print_always "========================="
  print_always "| Command:    $COMMAND"
  print_always "| Subcommand: $SUBCOMMAND"
  print_always "| Profile:    $PROFILE"
  print_always "| Name:       $NAME"
  print_always "| Force:      $FORCE"
  print_always "| Quiet:      $QUIET"
  print_always "| Dry Run:    $DRY_RUN"
  print_always "===================="
}
# ==============================================================
# Do
# ==============================================================
do_apply() {
  #setup-pre-apply
  #do_apply_install
  #do_apply_config
  #setup-post-apply
  print_msg "${FUNCNAME[0]}"
}

do_apply_install() {
  #setup-pre-apply-install
  #setup-post-apply-install
  print_msg "${FUNCNAME[0]}"
}

do_apply_config() {
  #setup-pre-apply-config
  #setup-post-apply-config
  print_msg "${FUNCNAME[0]}"
}

do_remove() {
  #setup-pre-remove
  #do_remove_install
  #do_remove_config
  #setup-post-remove
  print_msg "${FUNCNAME[0]}"
}

do_remove_install() {
  #setup-pre-remove-install
  #setup-post-remove-install
  print_msg "${FUNCNAME[0]}"
}

do_remove_config() {
  #setup-pre-remove-config
  #setup-post-remove-config
  print_msg "${FUNCNAME[0]}"
}

do_list_profiles() {
  print_msg "${FUNCNAME[0]}"
}

do_list_configs() {
  print_msg "${FUNCNAME[0]}"
}
do_list_setups() {
  print_msg "${FUNCNAME[0]}"
}
do_list_profile_configs() {
  print_msg "${FUNCNAME[0]}"
}
do_list_profile_setups() {
  print_msg "${FUNCNAME[0]}"
}
do_list_profile_installs() {
  print_msg "${FUNCNAME[0]}"
}

do_create_profile() {
  new_profile "${NAME}"
}
do_create_install() {
  # create install in profile folder for current OS
  print_msg "${FUNCNAME[0]}"
}
do_create_setup() {
  # create new setup folder
  # create hook scripts
  print_msg "${FUNCNAME[0]}"
}
do_create_config() {
  # craete new config folder
  # TBD
  print_msg "${FUNCNAME[0]}"
}

# ==============================================================
# Command
# ==============================================================

cmd_apply() {
  if [[ -z "$SUBCOMMAND" ]]; then
    do_apply
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    do_apply_install
  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    do_apply_config
  fi
}

cmd_remove() {
  if [[ -z "$SUBCOMMAND" ]]; then
    do_remove
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    do_remove_install
  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    do_remove_config
  fi
}

cmd_list() {
  if [ "$SUBCOMMAND" == "profile" ]; then
    do_list_profiles
  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    if [ -z "$PROFILE" ]; then
      do_list_configs
    else
      do_list_profile_configs
    fi
  fi

  if [ "$SUBCOMMAND" == "setup" ]; then
    if [ -z "$PROFILE" ]; then
      do_list_setups
    else
      do_list_profile_setups
    fi
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    if [ -z "$PROFILE" ]; then
      print_always "Error: No profile given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      do_list_profile_installs
    fi
  fi
}

cmd_new() {
  if [ "$SUBCOMMAND" == "profile" ]; then
    if [ -z "$NAME" ]; then
      print_always "Error: No name given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      do_create_profile
    fi
  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    if [ -z "$NAME" ]; then
      print_always "Error: No name given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      do_create_config
    fi
  fi

  if [ "$SUBCOMMAND" == "setup" ]; then
    if [ -z "$NAME" ]; then
      print_always "Error: No name given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      do_create_setup
    fi
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    if [ -z "$NAME" ]; then
      print_always "Error: No name given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      do_create_install
    fi
  fi

}

#cmd_doctor() {}

# ==============================================================
# Usage
# ==============================================================
_usage_apply() {
  cat <<EOF
Usage: dickidots apply [subcommand] -p <profile_name>

Subcommands:
  (default)    Apply both config and install for the profile
  config       Apply only the configuration files for the profile
  install      Apply only the installation scripts for the profile

Options:
  -p, --profile <name>    The name of the profile to target (Required)
EOF
}

_usage_remove() {
  cat <<EOF
Usage: dickidots remove [subcommand] -p <profile_name>

Subcommands:
  (default)    Apply both config and install for the profile
  config       Apply only the configuration files for the profile
  install      Apply only the installation scripts for the profile

Options:
  -p, --profile <name>    The name of the profile to target (Required)
EOF
}

_usage_list() {
  cat <<EOF
Usage: dickidots list <subcommand> [-p <profile_name>]

Subcommands:
  profile    List all available profiles
  config     List configuration files (globally, or filtered by profile)
  setup      List setup configurations (globally, or filtered by profile)
  install    List installation scripts for a specific profile

Options:
  -p, --profile <name>    Filter results by a specific profile
EOF
}

_usage_new() {
  cat <<EOF
Usage: dickidots new <subcommand> -n <name>

Subcommands:
  profile    Create a new profile template
  config     Create a new configuration template
  setup      Create a new setup template
  install    Create a new install template

Options:
  -n, --name <name>    The name of the item to create (Required)
EOF
}

_usage_doctor() {
  cat <<EOF
Usage: dickidots doctor [subcommand]

Check the health of your dotfile environment and dependencies.

Subcommands:
  fix        Attempt to automatically repair any discovered issues

EOF
}

_usage_main() {
  cat <<EOF
Usage: $(basename "$0") [-f|--force] [-q|--quiet] [-d|--dry-run] <command> [<subcommand>] [options]

A dotfile and system configuration manager.

Global Flags:
  -f, --force      Force execution without prompting
  -q, --quiet      Suppress informational output
  -d, --dry-run    Show what would be done without making changes
  -h, --help       Show this help message

Commands:
  apply     Apply profiles, configurations, or installations
  remove    Remove profiles, configurations, or installations
  list      List available profiles, configs, setups, or installs
  new       Create a new profile, config, setup, or install template
  doctor    Check system health and prerequisites

Run 'dickidots <command> --help' for details on specific subcommands.
EOF
}

usage() {
  local command="${1:-}"

  case "$command" in
    apply) _usage_apply "$@" ;;
    remove) _usage_remove "$@" ;;
    list) _usage_list "$@" ;;
    new) _usage_new "$@" ;;
    doctor) _usage_doctor "$@" ;;
    *) _usage_main ;;
  esac
}

# ==============================================================
# Entry point
# ==============================================================

# ensure stow is installed
if ! command_exists stow; then
  print_always "Error: stow is not installed. Please install stow and try again."
  exit 1
fi

# ensure a command was passed
if [[ "$#" -eq 0 ]]; then
  print_always "Error: no command given."
  usage
  exit 1
fi

# parse global flags
FORCE=false
QUIET=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f | --force)
      FORCE=true
      shift
      ;;
    -q | --quiet)
      QUIET=true
      shift
      ;;
    -d | --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      print_always "Unknown global flag: '$1'"
      print_always ""
      usage
      exit 1
      ;;
    *) break ;; # No more flags, we hit the command!
  esac
done

# If no arguments are left after stripping flags, then no commands were passed
if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

# parse command
COMMAND="$1"
shift

# parse subcommand
SUBCOMMAND=""
case "$COMMAND" in
  apply | remove)
    # Check if the next argument is a known subcommand
    case "$1" in
      config | install)
        SUBCOMMAND="$1"
        shift
        ;;
      -*)
        # It's a flag (like -p), no subcommand
        ;;
      *)
        print_always "Unknown subcommand for $COMMAND: '$1'"
        print_always ""
        usage "$COMMAND"
        exit 1
        ;;
    esac
    ;;
  list | new)
    # Check if the next argument is a known subcommand
    case "$1" in
      profile | config | install | setup)
        SUBCOMMAND="$1"
        shift
        ;;
      -*)
        # It's a flag (like -p), no subcommand
        ;;
      *)
        print_always "Unknown subcommand for $COMMAND: '$1'"
        print_always ""
        usage "$COMMAND"
        exit 1
        ;;
    esac
    ;;
  doctor)
    # Check if the next argument is a known subcommand
    case "$1" in
      fix)
        SUBCOMMAND="$1"
        shift
        ;;
      *)
        echo "Unknown subcommand for $COMMAND: $1"
        print_always ""
        usage "$COMMAND"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Unknown command: '$COMMAND'"
    print_always ""
    usage
    exit 1
    ;;
esac

# parse command option
NAME=""
PROFILE=""
case "$COMMAND" in
  new)
    case "$1" in
      -n | --name)
        NAME="$2"
        ;;
      *)
        print_always "Unknown option '$1'."
        print_always ""
        usage "$COMMAND"
        exit 1
        ;;
    esac
    ;;
  apply | remove)
    case "$1" in
      -p | --profile)
        PROFILE="$2"
        ;;
      *)
        print_always "Unknown option '$1'."
        print_always ""
        usage "$COMMAND"
        exit 1
        ;;
    esac
    ;;
  list)
    case "$1" in
      -p | --profile)
        PROFILE="$2"
        ;;
      *)
        ;;
    esac
    ;;
esac

# Ensure name is given for new
if [[ "$COMMAND" == @(new) ]]; then
  if [[ -z $NAME ]]; then
    print_always "Error: No name given"
    print_always ""
    usage "$COMMAND"
    exit 1
  fi

fi

# Ensure profile is given for apply/remove
if [[ "$COMMAND" == @(apply|remove) ]]; then
  if [[ -z $PROFILE ]]; then
    print_always "Error: No profile given"
    print_always ""
    usage "$COMMAND"
    exit 1
  fi
fi

# Ensure given profile exists
if [[ ! -z $PROFILE ]]; then
  if ! dir_exists "${_PROFILE_DIR}/${PROFILE}"; then
    print_always "Error: Profile ${PROFILE} doesn't exist"
    exit 1
  fi
fi

case "$COMMAND" in
  apply) cmd_apply ;;
  remove) cmd_remove ;;
  list) cmd_list ;;
  new) cmd_new ;;
  doctor) cmd_doctor ;;

  *)
    print_always "Unknown command '$COMMAND'"
    print_always ""
    usage
    exit 0
    ;;
esac
