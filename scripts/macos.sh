#!/bin/bash

set -e  # Exit on any error

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  export HOMEBREW_NO_ANALYTICS=1
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update
brew bundle --file ./scripts/Brewfile
# brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs brew install --cask

brew cleanup
