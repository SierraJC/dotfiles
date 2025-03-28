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

ask() {
    read -p "$1 (y/N) " response
    [[ "$response" =~ ^[yY]$ ]]
}

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 1
fi

if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
  readonly WSL=1
else
  readonly WSL=0
fi

# Install a bunch of debian packages.
function install_packages() {
  title "📦 Installing packages"
  local packages=(
    build-essential
    ca-certificates
    curl
    wget
    git     # Version control
    zsh     # Z shell
    stow    # Symlink manager
    zoxide  # switch between most used directories
    htop    # prettier top
    jq      # JSON processor
    fzf     # Fuzzy finder
    fd-find # Better find
  )

  if ((WSL)); then
    packages+=(wslu)
  else
    packages+=()
  fi

  sudo apt-get update
  sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y'
  sudo apt-get install -y "${packages[@]}"
  sudo apt-get autoremove -y
  sudo apt-get autoclean

  # Create a symlink for fdfind to fd for compatibility
  ln -s $(which fdfind) $HOME/.local/bin/fd
}

function install_docker() {
  title "📦 Installing Docker"
  # if (( WSL )); then
  #   local release
  #   release="$(lsb_release -cs)"
  #   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  #   sudo apt-key fingerprint 0EBFCD88
  #   sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu
  #     $release
  #     stable"
  #   sudo apt-get update -y
  #   sudo apt-get install -y docker-ce
  # else
  #   sudo apt-get install -y docker.io
  # fi

  # Add Docker's official GPG key:
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce containerd.io docker-buildx-plugin docker-compose-plugin

  sudo usermod -aG docker "$USER"
}

function install_gh() {
  title "📦 Installing GitHub CLI"
  sudo mkdir -p -m 755 /etc/apt/keyrings

  sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages \
    stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt update
  sudo apt install gh -y

# cant do without gh login/token, ugh
#  title "📦‍ Installing gh extensions"
#  gh extension install github/gh-copilot
}

function install_tenv() {
  title "📦 Installing TENV (OpenTofu / Terraform / Terragrunt)"
  tempFile=$(mktemp)
  LATEST_VERSION=$(curl --silent https://api.github.com/repos/tofuutils/tenv/releases/latest | jq -r .tag_name)
  curl -o "$tempFile" -L "https://github.com/tofuutils/tenv/releases/latest/download/tenv_${LATEST_VERSION}_amd64.deb"
  sudo dpkg -i "$tempFile"
  rm -f "$tempFile"
  # tenv tf install latest
}

function install_ansible() {
  title "📦 Installing Ansible"
  sudo apt install software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible
}

function win_install_fonts() {
  local dst_dir
  dst_dir="$(cmd.exe /c 'echo %LOCALAPPDATA%\Microsoft\Windows\Fonts' 2>/dev/null | sed 's/\r$//')"
  dst_dir="$(wslpath "$dst_dir")"
  mkdir -p "$dst_dir"
  local src
  for src in "$@"; do
    local file="$(basename "$src")"
    if [[ ! -f "$dst_dir/$file" ]]; then
      cp -f "$src" "$dst_dir/"
    fi
    local win_path
    win_path="$(wslpath -w "$dst_dir/$file")"
    # Install font for the current user. It'll appear in "Font settings".
    reg.exe add \
      'HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' \
      /v "${file%.*} (TrueType)" /t REG_SZ /d "$win_path" /f 2>/dev/null
  done
}

# Install a decent monospace font.
function install_fonts() {
  ((WSL)) || return 0
  title "📦 Installing fonts"
  win_install_fonts ~/.dotfiles/fonts/.local/share/fonts/NerdFonts/*.ttf
}

function install_locale() {
  sudo locale-gen en_AU.UTF-8
  sudo update-locale
}

function fix_locale() {
  sudo tee /etc/default/locale >/dev/null <<<'LC_ALL="en_AU.UTF-8"'
}

# Ensure no-write for group and others
umask g-w,o-w

install_packages
# install_locale
install_docker
install_gh
ask "Install tenv?" && install_tenv
ask "Install ansible?" && install_ansible
install_fonts

# fix_locale
