#!/bin/env bash

# Usage: bash scripts/install.sh
#        NONINTERACTIVE=1 bash scripts/install.sh

if [ "$(id -u)" = "0" ]; then
  echo "/!\\ This script should not be run as root /!\\"
  exit 1
fi

export USER="${USER:-$(whoami)}"

cd "$HOME/.dotfiles" || exit 1

# MARK: Utility functions

bold=$(tput bold)
reset=$(tput sgr0)

is_mac()   { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }
is_wsl()   { is_linux && grep -qi microsoft /proc/version 2>/dev/null; }

title() { echo "${bold}==> $1${reset}"; echo; }
warn()  { tput setaf 1; echo "/!\\ $1 /!\\"; tput sgr0; }

ask() {
  [[ "${NONINTERACTIVE:-0}" == "1" ]] && return 1
  read -p "$1 (y/N) " response
  [[ "$response" =~ ^[yY]$ ]]
}

# MARK: Step functions

ensure_directories() {
  title "Creating prerequisite directories"
  local dirs=(
    "$HOME/.config/gh"
    "$HOME/.config/iterm2"
    "$HOME/.config/tmux"
    "$HOME/.claude"
    "$HOME/.local/share"
    "$HOME/.local/bin"
  )
  mkdir -p "${dirs[@]}"
}

install_apt_prerequisites() {
  is_linux || return 0

  title "Installing apt prerequisites"

  local packages=(
    build-essential
    gcc
    git
    procps
    curl
    file
  )
  if is_wsl; then
    packages+=(wslu)
  fi

  sudo apt-get update
  sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y'
  sudo apt-get install -y "${packages[@]}"
  sudo apt-get autoremove -y
  sudo apt-get autoclean
}

install_homebrew() {
  if command -v brew &>/dev/null; then
    warn "Homebrew already installed"
    return 0
  fi

  title "Installing Homebrew"
  export HOMEBREW_NO_ANALYTICS=1

  local brew_installer
  brew_installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if is_mac; then
    if ! /bin/bash -c "$brew_installer"; then
      warn "Could not install Homebrew. Exiting."
      exit 1
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    if ! NONINTERACTIVE=1 /bin/bash -c "$brew_installer"; then
      warn "Could not install Homebrew. Exiting."
      exit 1
    fi
    if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi
}

install_homebrew_packages() {
  title "Installing Homebrew packages"
  brew analytics off
  brew update
  brew bundle --file ./scripts/Brewfile --no-upgrade
  brew cleanup
}

# setup_iterm2() {
#   is_mac || return 0
#   [ -d "/Applications/iTerm.app" ] || return 0

#   title "Setting up iTerm2 preferences"
#   defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"
#   defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
#   defaults write com.googlecode.iterm2.plist "NoSyncNeverRemindPrefsChangesLostForFile_selection" -int 2
# }

backup_conflicting_files() {
  title "Backing up files that may conflict with stow"
  local files=(
    .bash_profile
    .bashrc
    .zshrc
    .gitconfig
    .config/gh/config.yml
  )
  for file in "${files[@]}"; do
    local target="$HOME/$file"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
      mv "$target" "${target}.old"
      echo "  moved $file → ${file}.old"
    fi
  done
}

run_stow() {
  title "Creating symlinks via stow"

  stow --restow stow

  for dir in */; do
    local pkg="${dir%/}"
    if ! stow --restow "$pkg" 2>&1; then
      warn "stow failed for '$pkg' (non-fatal)"
    fi
  done
}

setup_fish_shell() {
  local fish_path
  fish_path=$(command -v fish 2>/dev/null) || return 0

  [ "$SHELL" != "$fish_path" ] || return 0

  if ! ask "Change login shell to fish ($fish_path)?"; then
    return 0
  fi

  if ! grep -qxF "$fish_path" /etc/shells; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  sudo chsh -s "$fish_path" "$USER"
  echo "Login shell changed to fish — restart your terminal to use it."
}

install_mise_tools() {
  command -v mise &>/dev/null || return 0

  title "Installing mise tools"

  if is_linux && [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  if ! mise install; then
    warn "mise install failed (non-fatal). Run 'mise install' manually later."
  fi
}

configure_git_local_files() {
  if ! ask "Configure git to ignore changes to *.local* files?"; then
    return 0
  fi

  title "Marking .local files as assume-unchanged"
  local files=(
    "zsh/.zshrc.local"
    "git/.gitconfig.local"
    "claude/.claude/.mcp.local.json"
    "fish/.config/fish/conf.d/abbr.local.fish"
    "mise/.config/mise/config.local.toml"
  )

  for file in "${files[@]}"; do
    if [ -f "$file" ]; then
      git update-index --assume-unchanged "$file" 2>/dev/null || true
      echo "  ✓ $file"
    fi
  done
}

remind_gh_auth() {
  command -v gh &>/dev/null || return 0
  if ! gh auth status &>/dev/null; then
    echo
    echo "[GitHub CLI] Not logged in. Run: ${bold}gh auth login${reset}"
  fi
}

# MARK: Main

main() {
  if is_mac; then
    title "🍎 Setting up Mac"
  elif is_linux; then
    title "🐧 Setting up Linux"
  else
    warn "Unsupported OS: $(uname -s)"
    exit 1
  fi

  sudo -v

  ensure_directories
  install_apt_prerequisites
  install_homebrew
  install_homebrew_packages
  # setup_iterm2
  backup_conflicting_files
  run_stow
  setup_fish_shell
  install_mise_tools
  configure_git_local_files
  remind_gh_auth

  local login_shell
  login_shell=$(getent passwd "$USER" | cut -d: -f7)
  echo
  title "Done! Launching ${login_shell##*/}"
  exec "$login_shell" -li
}

main "$@"
