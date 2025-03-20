#!/bin/bash

set -e # Exit on any error

if [[ "$(</proc/version)" == *[Mm]icrosoft* ]] 2>/dev/null; then
  readonly WSL=1
else
  readonly WSL=0
fi

# Install a bunch of debian packages.
function install_packages() {
  local packages=(
    build-essential
    ca-certificates
    curl
    wget
    git    # Version control
    zsh    # Z shell
    stow   # Symlink manager
    zoxide # switch between most used directories
    htop   # prettier top
    jq     # JSON processor
    fzf    # Fuzzy finder
  )

  if (( WSL )); then
    packages+=(wslu)
  else
    packages+=()
  fi

  sudo apt-get update
  sudo bash -c 'DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::options::=--force-confdef -o DPkg::options::=--force-confold upgrade -y'
  sudo apt-get install -y "${packages[@]}"
  sudo apt-get autoremove -y
  sudo apt-get autoclean
}

function install_docker() {
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
  # local v="2.68.1"
  # ! command -v gh &>/dev/null || [[ "$(gh --version)" != */v"$v" ]] || return 0
  # local deb
  # deb="$(mktemp)"
  # curl -fsSL "https://github.com/cli/cli/releases/download/v${v}/gh_${v}_linux_amd64.deb" > "$deb"
  # sudo dpkg -i "$deb"
  # rm "$deb"

  sudo mkdir -p -m 755 /etc/apt/keyrings

  sudo curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages \
    stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt update
  sudo apt install gh -y
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
  win_install_fonts ~/.local/share/fonts/NerdFonts/*.ttf
}

function install_locale() {
  sudo locale-gen en_AU.UTF-8
  sudo update-locale
}

function fix_locale() {
  sudo tee /etc/default/locale >/dev/null <<<'LC_ALL="C.UTF-8"'
}

# Ensure no-write for group and others
umask g-w,o-w

install_packages
# install_locale
install_docker
install_gh
install_fonts

# fix_locale
