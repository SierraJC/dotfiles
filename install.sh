#!/bin/bash

set -e  # Exit on any error

# Check if running as root
if [ "$(id -u)" = "0" ]; then
    echo "This script should not be run as root"
    exit 1
fi

osname=$(uname)

if [ "$osname" != "Darwin" ]; then
  echo "This script only supports macOS. Exiting..."
  exit 1
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Setting up Mac..."

if [ -z "$XDG_CONFIG_HOME" ]; then
  echo "Setting up ~/.config directory..."
  if [ ! -d "${HOME}/.config" ]; then
    mkdir "${HOME}/.config"
  fi
  export XDG_CONFIG_HOME="${HOME}/.config"
fi

mkdir -p "$HOME/.config"
rm -rf "$HOME/.zshrc"

source macos.sh
source shell.sh
source stow.sh


echo "Setting up iTerm2 preferences..."

if [ -d "/Applications/iTerm.app" ]; then
  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  # Tell iTerm2 to save preferences automatically
  defaults write com.googlecode.iterm2.plist "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2
fi

# source ~/.zshrc