# Dotfiles

A personal dotfiles repository for quickly setting up a consistent development environment across macOS and Ubuntu Linux systems. It uses GNU Stow for symlink management and Homebrew / Mise for package management.

## Requirements

- `git` must be installed.
- macOS or Ubuntu Linux
  - On macOS, Homebrew will be installed if not present.
  - On Ubuntu, Homebrew (Linuxbrew) will be installed automatically after installing prerequisites via apt.

## Installation

To set up, assuming `git` is already installed:

```bash
git clone https://github.com/sierrajc/dotfiles.git $HOME/.dotfiles && \
cd $HOME/.dotfiles && \
bash scripts/install.sh
```
