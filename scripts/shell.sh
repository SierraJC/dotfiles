#!/bin/bash

# Source common utility functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

clone_or_pull() {
  repo_url=$1
  directory=$2

  if [ ! -d "$directory" ]; then
    git clone "$repo_url" "$directory" || exit 1
  else
    (cd "$directory" && git pull "$repo_url") || exit 1
  fi
}

# Install zsh plugins
install_plugins() {
  ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
  type=$1
  name=$2
  repo=$3

  if [ "$type" = "theme" ]; then
    plugin_path=$ZSH_CUSTOM/themes
  elif [ "$type" = "plugin" ]; then
    plugin_path=$ZSH_CUSTOM/plugins
  else
    warning "Invalid type: $type"
    return 1
  fi

  plugin_path=$plugin_path/$name

  clone_or_pull "$repo" "$plugin_path"
}

title "🐚 Setting up Zsh shell"

# Check for Oh My Zsh and install if we don't have it
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#   title "Installing Oh My Zsh"
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# fi

# title "Installing Zsh plugins"
# install_plugins theme powerlevel10k https://github.com/romkatv/powerlevel10k.git

# install_plugins plugin you-should-use https://github.com/MichaelAquilina/zsh-you-should-use.git
# install_plugins plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
# install_plugins plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

# Check if the current shell is already zsh (either system or Homebrew version)
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/opt/homebrew/bin/zsh" ]; then
  sudo chsh -s /bin/zsh $USER
  echo "Your shell has been changed to zsh, please restart your terminal or tab"
fi
