#!/bin/bash

set -e # Exit on any error

echo "Setup configs via stow"

stow --restow stow

for d in $(ls -d */); do
  stow --restow $d
done
