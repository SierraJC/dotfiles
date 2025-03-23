#!/bin/bash

set -e # Exit on any error

bold=$(tput bold)
reset=$(tput sgr0)

title() {
  echo "${bold}==> $1${reset}"
  echo
}

warning() {
  tput setaf 1
  echo "/!\\ $1 /!\\"
  tput sgr0
}

title "📦 Setting up symlinks"

stow --restow stow

for d in $(ls -d */); do
  stow --restow $d
done
