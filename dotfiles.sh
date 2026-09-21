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

_prog_name() {
  basename "${BASH_SOURCE[0]:-$0}"
}

_usage_main() {
  cat <<EOF
Usage: $(_prog_name) [global options] <command> [<subcommand>] [options]

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

Run '$(_prog_name) <command> --help' for details on specific commands.
EOF
}

_usage_apply() {
  cat <<EOF
Usage: $(_prog_name) apply [subcommand] -p <profile_name>

Apply configuration files, installation scripts, or setups for a profile.

Subcommands:
  (default)    Apply both config and install for the profile
  config       Apply only configuration files
  install      Apply only installation scripts

Options:
  -p, --profile <name>    Target profile name (Required)
  -h, --help              Show command help
EOF
}

_usage_remove() {
  cat <<EOF
Usage: $(_prog_name) remove [subcommand] -p <profile_name>

Remove configuration files or uninstall items associated with a profile.

Subcommands:
  (default)    Remove both config and install for the profile
  config       Remove only configuration files
  install      Remove only installation scripts

Options:
  -p, --profile <name>    Target profile name (Required)
  -h, --help              Show command help
EOF
}

_usage_list() {
  cat <<EOF
Usage: $(_prog_name) list <subcommand> [-p <profile_name>]

List managed configurations, profiles, setups, or dependencies.

Subcommands:
  profile    List all available profiles
  config     List configuration files (global, or filtered by profile)
  setup      List setup routines (global, or filtered by profile)
  install    List installation items for a profile (Requires -p)
  deps       List profile dependencies for a profile (Requires -p)

Options:
  -p, --profile <name>    Filter or target a specific profile
  -h, --help              Show command help
EOF
}

_usage_new() {
  cat <<EOF
Usage: $(_prog_name) new <subcommand> [options]

Create boilerplate templates for new components.

Subcommands:
  profile    Create a new profile template           (Requires -n <name>)
  config     Create a new configuration template     (Requires -n <name>)
  setup      Create a new setup script template      (Requires -n <name>)
  install    Create a new install manifest template  (Requires -p <profile>)

Options:
  -n, --name <name>        Name of the profile, config, or setup to create
  -p, --profile <profile>  Target profile name for an install manifest
  -h, --help               Show command help
EOF
}

_usage_doctor() {
  cat <<EOF
Usage: $(_prog_name) doctor [subcommand]

Check environment health, missing dependencies, and system state.

Subcommands:
  (default)    Run diagnostic checks
  fix          Attempt automatic resolution of discovered issues

Options:
  -h, --help   Show command help
EOF
}

usage() {
  local command="${1:-}"

  case "$command" in
    apply)  _usage_apply ;;
    remove) _usage_remove ;;
    list)   _usage_list ;;
    new)    _usage_new ;;
    doctor) _usage_doctor ;;
    *)      _usage_main ;;
  esac
}

debug(){
  echo "COMMAND: ${COMMAND}"
  echo "SUBCOMMAND: ${SUBCOMMAND}"
  echo "FORCE: ${FORCE}"
  echo "QUIET: ${QUIET}"
  echo "DRY RUN: ${DRY_RUN}"
  echo "PROFILE: ${PROFILE}"
  echo "NAME: ${NAME}"
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
