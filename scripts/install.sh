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

# Check if running as root
if [ "$(id -u)" = "0" ]; then
  warning "This script should not be run as root"
  exit 1
fi

cd $HOME/.dotfiles || exit 1

osname=$(uname -s) # "Linux" or "Darwin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$osname" = "Darwin" ]; then
  readonly isMac=1
  readonly isLinux=0
  title "🍎 Setting up Mac..."
elif [ "$osname" = "Linux" ]; then
  readonly isMac=0
  readonly isLinux=1
  title "🐧 Setting up Linux..."
else
  warning "This script only supports Linux and macOS. Exiting..."
  exit 1
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

if [ -z "$XDG_CONFIG_HOME" ]; then
  title "🏠 Setting up ~/.config directory"
  if [ ! -d "${HOME}/.config" ]; then
    mkdir -p "${HOME}/.config"
  fi
  export XDG_CONFIG_HOME="${HOME}/.config"
fi

# Double check that we're on macOS before continuing
if ((isMac)); then
  source "$SCRIPT_DIR/macos.sh"
elif ((isLinux)); then
  source "$SCRIPT_DIR/ubuntu.sh"
fi

source "$SCRIPT_DIR/shell.sh"

# Clean up existing files that might conflict with stow
echo
warning "Backing up existing files that might conflict with stow..."
files=(
  ".zshrc"
  ".gitconfig"
)
for file in "${files[@]}"; do
  if [ -f "$HOME/$file" ]; then
    mv "$HOME/$file" "$HOME/${file}.old"
  fi
done

source "$SCRIPT_DIR/stow.sh"

# GitHub CLI: Authenticate with your GitHub account if the user is not logged in
if command -v gh &>/dev/null && ! gh auth status &>/dev/null; then
  echo "[GitHub CLI] You are not logged into any GitHub hosts. To log in, run: ${bold}gh auth login${reset}"
fi

# source ~/.zshrc
