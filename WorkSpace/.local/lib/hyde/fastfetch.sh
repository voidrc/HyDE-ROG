#!/usr/bin/env bash

# Early load to maintain fastfetch speed
if [ -z "${*}" ]; then
  clear
  exec fastfetch --logo-type kitty
  exit
fi

USAGE() {
  cat <<USAGE
Usage: fastfetch [commands] [options]

commands:
  logo    Display a random logo from --local

options:
  -h, --help,     Display command's help message

USAGE
}

# Source state and os-release
# shellcheck source=/dev/null
[ -f "$HYDE_STATE_HOME/staterc" ] && source "$HYDE_STATE_HOME/staterc"
# shellcheck disable=SC1091
[ -f "/etc/os-release" ] && source "/etc/os-release"

# Set the variables
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"

# Parse the main command
case $1 in
logo)
  random_local() {
    find -L "${confDir}/fastfetch/logo" -maxdepth 1 -type f \( -name "wall.quad" -o -name "wall.sqre" -o -name "*.webp" -o -name "*.icon" -o -name "*.jpeg" -o -name "*logo*" -o -name "*.png" \) ! -path "*/wall.set*" ! -path "*/wallpapers/*.png" 2>/dev/null | shuf -n 1
  }
  help() {
    cat <<HELP
Usage: ${0##*/} logo [option]

options:
  --local   Display a logo inside the fastfetch logo directory (default)
  *help*    Display this help message

Example: ${0##*/} logo --local
HELP
  }

  shift
  [ -z "${*}" ] && random_local && exit
  [[ "$1" = *"help"* ]] && help && exit
  [[ "$1" = "--local" ]] && random_local && exit
  # If any other option is given, fallback to --local
  random_local && exit
  ;;
help | --help | -h)
  USAGE
  ;;
*)
  clear
  exec fastfetch --logo-type kitty
  ;;
esac
