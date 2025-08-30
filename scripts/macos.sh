#!/bin/bash

# Source common utility functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if ((!isMac)); then
  exit 1
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  export HOMEBREW_NO_ANALYTICS=1
  title " 🍺 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

title " 🍺 Installing Homebrew packages"
brew update
brew bundle --file ./scripts/Brewfile

brew cleanup

# Install yazi theme
ya pkg add yazi-rs/flavors:catppuccin-mocha

if [ -d "/Applications/iTerm.app" ]; then
  title "Setting up iTerm2 preferences"
  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  # Tell iTerm2 to save preferences automatically
  defaults write com.googlecode.iterm2.plist "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2
fi
