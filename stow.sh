#!/bin/bash

set -e  # Exit on any error

echo "Setup configs via stow"
cd $HOME/.dotfiles || exit 1

stow --restow stow

for d in $(ls -d */); do
  stow --restow $d
done