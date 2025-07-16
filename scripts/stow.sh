#!/bin/bash

# Source common utility functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Directories to create before symlinks are made (to avoid symlinking the whole folder to dotfiles)
dirs_to_create=(
  "$HOME/.config/gh"
  "$HOME/.config/iterm2"
  "$HOME/.claude"
)

for dir in "${dirs_to_create[@]}"; do
  mkdir -p "$dir"
done

title "📦 Setting up symlinks"

stow --restow stow

for d in $(ls -d */); do
  stow --restow $d
done
