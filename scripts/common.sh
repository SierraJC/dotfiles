#!/bin/bash

# Common utility functions for dotfiles installation scripts

set -e # Exit on any error

bold=$(tput bold)
reset=$(tput sgr0)

function title() {
  local msg="$1"
  echo "${bold}==> $msg${reset}"
  echo
}

function warning() {
  local msg="$1"
  tput setaf 1
  echo "/!\\ $msg /!\\"
  tput sgr0
}

function ask() {
  local msg="$1"
  read -p "$msg (y/N) " response
  [[ "$response" =~ ^[yY]$ ]]
}

# Platform detection variables
osname=$(uname -s) # "Linux" or "Darwin"

if [ "$osname" = "Darwin" ]; then
  readonly isMac=1
  readonly isLinux=0
elif [ "$osname" = "Linux" ]; then
  readonly isMac=0
  readonly isLinux=1
else
  readonly isMac=0
  readonly isLinux=0
fi

# WSL detection for Linux systems
if ((isLinux)) && [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
  readonly isWSL=1
else
  readonly isWSL=0
fi
