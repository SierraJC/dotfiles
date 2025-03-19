#!/bin/bash

set -e # Exit on any error

# Check if running as root
if [ "$(id -u)" = "0" ]; then
  echo "This script should not be run as root"
  exit 1
fi

cd $HOME/.dotfiles || exit 1

osname=$(uname) # "Linux" or "Darwin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$osname" = "Darwin" ]; then
  readonly isMac=1
  readonly isLinux=0
  echo "Setting up Mac..."
elif [ "$osname" = "Linux" ]; then
  readonly isMac=0
  readonly isLinux=1
  echo "Setting up Linux..."
else
  echo "This script only supports Linux and macOS. Exiting..."
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
  echo "Setting up ~/.config directory..."
  if [ ! -d "${HOME}/.config" ]; then
    mkdir -p "${HOME}/.config"
  fi
  export XDG_CONFIG_HOME="${HOME}/.config"
fi

mv "$HOME/.zshrc" "$HOME/.zshrc.old"
mv "$HOME/.gitconfig" "$HOME/.gitconfig.old"

# Double check that we're on macOS before continuing
if ((isMac)); then
  source "$SCRIPT_DIR/macos.sh"
elif ((isLinux)); then
  source "$SCRIPT_DIR/ubuntu.sh"
fi

source "$SCRIPT_DIR/shell.sh"
source "$SCRIPT_DIR/stow.sh"

if ((isMac)); then
  echo "Setting up iTerm2 preferences..."

  if [ -d "/Applications/iTerm.app" ]; then
    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"

    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

    # Tell iTerm2 to save preferences automatically
    defaults write com.googlecode.iterm2.plist "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2
  fi
fi

# source ~/.zshrc
