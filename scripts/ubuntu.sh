#!/bin/bash

# Source common utility functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if ((!isLinux)); then
  exit 1
fi

function get_github_latest_version() {
  local repo="$1"
  curl --silent "https://api.github.com/repos/${repo}/releases/latest" | jq -r .tag_name
}

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
    fd-find # Better find
    ripgrep # Better grep
    unzip   # Archive extraction
  )

  if ((isWSL)); then
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
  ln -sf $(which fdfind) $HOME/.local/bin/fd
}

function install_docker() {
  title "📦 Installing Docker"
  # if (( isWSL )); then
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

function install_fzf() {
  title "📦 Installing fzf from GitHub"

  # Get latest release version and strip 'v' prefix if present
  local latest_version=$(get_github_latest_version "junegunn/fzf" | sed 's/^v//')

  # Download and extract fzf binary
  local temp_dir=$(mktemp -d)
  curl -L "https://github.com/junegunn/fzf/releases/download/v${latest_version}/fzf-${latest_version}-linux_amd64.tar.gz" | tar -xz -C "$temp_dir"

  # Install to ~/.local/bin
  mkdir -p "$HOME/.local/bin"
  mv "$temp_dir/fzf" "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/fzf"
  rm -rf "$temp_dir"
}

function install_yazi() {
  title "📦 Installing yazi from GitHub"

  # Get latest release version and strip 'v' prefix if present
  local latest_version=$(get_github_latest_version "sxyazi/yazi" | sed 's/^v//')

  # Download and extract binary
  local temp_dir=$(mktemp -d)
  curl -L "https://github.com/sxyazi/yazi/releases/download/v${latest_version}/yazi-x86_64-unknown-linux-gnu.zip" -o "$temp_dir/yazi.zip"
  unzip -q "$temp_dir/yazi.zip" -d "$temp_dir"

  # Install to ~/.local/bin
  mkdir -p "$HOME/.local/bin"
  mv "$temp_dir/yazi-x86_64-unknown-linux-gnu/"{yazi,ya} "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/"{yazi,ya}
  rm -rf "$temp_dir"

  # Install theme via yazi cli
  ya pkg add yazi-rs/flavors:catppuccin-mocha || true
}

function install_delta() {
  title "📦 Installing Delta (git diff tool)"
  temp_file=$(mktemp)
  latest_version=$(get_github_latest_version "dandavison/delta")
  curl -o "$temp_file" -L "https://github.com/dandavison/delta/releases/download/${latest_version}/git-delta_${latest_version}_amd64.deb"
  sudo dpkg -i "$temp_file"
  rm -f "$temp_file"
}

function install_tenv() {
  title "📦 Installing TENV (OpenTofu / Terraform / Terragrunt)"
  temp_file=$(mktemp)
  latest_version=$(get_github_latest_version "tofuutils/tenv")
  curl -o "$temp_file" -L "https://github.com/tofuutils/tenv/releases/latest/download/tenv_${latest_version}_amd64.deb"
  sudo dpkg -i "$temp_file"
  rm -f "$temp_file"
  # tenv tf install latest
}

function install_ansible() {
  title "📦 Installing Ansible"
  sudo apt install software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible
}

function install_fish() {
  title "📦 Installing Fish Shell"
  sudo apt-add-repository --yes ppa:fish-shell/release-4
  sudo apt update
  sudo apt install -y fish
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
  ((isWSL)) || return 0
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
install_fzf
install_yazi
install_delta
ask "Install fish shell?" && install_fish
ask "Install tenv?" && install_tenv
ask "Install ansible?" && install_ansible
install_fonts

# fix_locale
