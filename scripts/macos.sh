#!/bin/bash

set -e # Exit on any error

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  export HOMEBREW_NO_ANALYTICS=1
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update
brew bundle --file ./scripts/Brewfile

brew cleanup

echo "Setting up iTerm2 preferences..."

if [ -d "/Applications/iTerm.app" ]; then
  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  # Tell iTerm2 to save preferences automatically
  defaults write com.googlecode.iterm2.plist "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2
fi