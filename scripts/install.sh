#!/bin/bash

# Check if running as root
if [ "$(id -u)" = "0" ]; then
  warning "This script should not be run as root"
  exit 1
fi

cd $HOME/.dotfiles || exit 1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/common.sh"

if ((isMac)); then
  title "🍎 Setting up Mac..."
elif ((isLinux)); then
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

# NOTE: Path must exist otherwise stow will symlink the entire ~/.local folder
if [ -z "$XDG_DATA_HOME" ]; then
  title "🏠 Setting up ~/.local/share directory"
  if [ ! -d "${HOME}/.local/share" ]; then
    mkdir -p "${HOME}/.local/share"
  fi
  export XDG_DATA_HOME="${HOME}/.local/share"
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
  ".config/gh/config.yml"
)
for file in "${files[@]}"; do
  if [ -f "$HOME/$file" ]; then
    mv "$HOME/$file" "$HOME/${file}.old"
  fi
done

source "$SCRIPT_DIR/stow.sh"

if ask "Configure git to ignore changes to *.local* files?"; then
  title "⚙️ Configuring files with git assume-unchanged"
  local_files=(
    "zsh/.zshrc.local"
    "git/.gitconfig.local"
    "claude/.claude/.mcp.local.json"
    "fish/.config/fish/conf.d/abbr.local.fish"
    "mise/.config/mise/config.local.toml"
  )

  for file in "${local_files[@]}"; do
    if [ -f "$file" ]; then
      git update-index --assume-unchanged "$file" 2>/dev/null || true
      echo "✓ Set assume-unchanged for $file"
      # Note: Undo with --no-assume-unchanged
      # List files marked as assume-unchanged
      # git ls-files -v | grep '^h'
    fi
  done
fi

# GitHub CLI: Authenticate with your GitHub account if the user is not logged in
if command -v gh &>/dev/null && ! gh auth status &>/dev/null; then
  echo "[GitHub CLI] You are not logged into any GitHub hosts. To log in, run: ${bold}gh auth login${reset}"
fi

# source ~/.zshrc
