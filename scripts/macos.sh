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

if [[ "$(uname -s)" != "Darwin" ]]; then
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

if [ -d "/Applications/iTerm.app" ]; then
  title "Setting up iTerm2 preferences"
  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  # Tell iTerm2 to save preferences automatically
  defaults write com.googlecode.iterm2.plist "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2
fi
