#!/usr/bin/env bash

shopt -s nullglob

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/core.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/profiles.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/configs.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/installs.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/setups.sh"

finish_msg() {
  if file_exists "$HOME/.profile"; then
    print_msg ""
    print_msg "----------------------------------------------------------------"
    print_msg "Done! Run 'source ~/.profile' to apply changes."
  fi
}

cmd_apply() {
  local cmd_configs=()
  local cmd_installs=()
  local cmd_setups=()
  resolve_profile_configs "$PROFILE" cmd_configs
  resolve_profile_installs "$PROFILE" cmd_installs
  resolve_profile_setups "$PROFILE" cmd_setups

  if [[ -z "$SUBCOMMAND" ]]; then
    execute_pre_apply cmd_setups

    execute_pre_install cmd_setups $DRY_RUN $FORCE $QUIET
    apply_installs cmd_installs $DRY_RUN $FORCE $QUIET
    execute_post_install cmd_setups $DRY_RUN $FORCE $QUIET

    execute_pre_config cmd_setups $DRY_RUN $FORCE $QUIET
    apply_configs cmd_configs $DRY_RUN $FORCE $QUIET
    execute_post_config cmd_setups $DRY_RUN $FORCE $QUIET

    execute_post_apply cmd_setups
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    execute_pre_install cmd_setups $DRY_RUN $FORCE $QUIET
    apply_installs cmd_installs $DRY_RUN $FORCE $QUIET
    execute_post_install cmd_setups $DRY_RUN $FORCE $QUIET

  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    execute_pre_config cmd_setups $DRY_RUN $FORCE $QUIET
    apply_configs cmd_configs $DRY_RUN $FORCE $QUIET
    execute_post_config cmd_setups $DRY_RUN $FORCE $QUIET
  fi

  finish_msg
}

cmd_remove() {
  local cmd_configs=()
  local cmd_installs=()
  local cmd_setups=()
  resolve_profile_configs "$PROFILE" cmd_configs
  resolve_profile_installs "$PROFILE" cmd_installs
  resolve_profile_setups "$PROFILE" cmd_setups

  if [[ -z "$SUBCOMMAND" ]]; then
    execute_pre_remove cmd_setups

    execute_pre_remove_install cmd_setups $DRY_RUN $FORCE $QUIET
    remove_installs cmd_installs $DRY_RUN $FORCE $QUIET
    execute_post_remove_install cmd_setups $DRY_RUN $FORCE $QUIET

    execute_pre_remove_config cmd_setups $DRY_RUN $FORCE $QUIET
    remove_configs cmd_configs $DRY_RUN $FORCE $QUIET
    execute_post_remove_config cmd_setups $DRY_RUN $FORCE $QUIET

    execute_post_remove cmd_setups
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    execute_pre_remove_install cmd_setups $DRY_RUN $FORCE $QUIET
    remove_installs cmd_installs $DRY_RUN $FORCE $QUIET
    execute_post_remove_install cmd_setups $DRY_RUN $FORCE $QUIET

  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    execute_pre_remove_config cmd_setups $DRY_RUN $FORCE $QUIET
    remove_configs cmd_configs $DRY_RUN $FORCE $QUIET
    execute_post_remove_config cmd_setups $DRY_RUN $FORCE $QUIET
  fi

  finish_msg
}

cmd_list() {
  if [ "$SUBCOMMAND" == "profile" ]; then
    list_profiles
  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    if [ -z "$PROFILE" ]; then
      list_configs
    else
      list_profile_configs "${PROFILE}"
    fi
  fi

  if [ "$SUBCOMMAND" == "setup" ]; then
    if [ -z "$PROFILE" ]; then
      list_setups
    else
      list_profile_setups "${PROFILE}"
    fi
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    if [ -z "$PROFILE" ]; then
      print_always "Error: No profile given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      list_profile_installs "${PROFILE}"
    fi
  fi

  if [ "$SUBCOMMAND" == "deps" ]; then
    if [ -z "$PROFILE" ]; then
      print_always "Error: No profile given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      list_profile_dependencies "${PROFILE}"
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
      new_profile "${NAME}" $DRY_RUN $FORCE $QUIET
    fi
  fi

  if [ "$SUBCOMMAND" == "config" ]; then
    if [ -z "$NAME" ]; then
      print_always "Error: No name given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      new_config "${NAME}" $DRY_RUN $FORCE $QUIET
    fi
  fi

  if [ "$SUBCOMMAND" == "setup" ]; then
    if [ -z "$NAME" ]; then
      print_always "Error: No name given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      new_setup "${NAME}" $DRY_RUN $FORCE $QUIET
    fi
  fi

  if [ "$SUBCOMMAND" == "install" ]; then
    if [ -z "$PROFILE" ]; then
      print_always "Error: No profile given"
      print_always ""
      usage "$COMMAND"
      exit 1
    else
      new_install "${PROFILE}" $DRY_RUN $FORCE $QUIET
    fi
  fi

}

#cmd_doctor() {}

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
  deps       List profile depenedencies for a specific profile

Options:
  -p, --profile <name>    Filter results by a specific profile
EOF
}

_usage_new() {
  cat <<EOF
Usage: dickidots new <subcommand> -p|-n <profile_name>|<name>

Subcommands:
  profile    Create a new profile template
  config     Create a new configuration template
  setup      Create a new setup template
  install    Create a new install template

Options:
  -n, --name <name>        The name of the setup, config, or profile to be create
  -p, --profile <profile>  The name of the profile to add a new install.binlist
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
FORCE=0
QUIET=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f | --force)
      FORCE=1
      shift
      ;;
    -q | --quiet)
      QUIET=1
      shift
      ;;
    -d | --dry-run)
      DRY_RUN=1
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
      profile | config | install | setup | deps)
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
