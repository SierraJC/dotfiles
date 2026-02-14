#!/bin/bash

# Test dotfiles installation in a disposable Ubuntu Docker container.
#
# Usage:
#   bash scripts/docker-test.sh          # Build image + drop into container
#   bash scripts/docker-test.sh --build  # Force rebuild the image
#   bash scripts/docker-test.sh --run    # Run install.sh automatically

set -e

IMAGE_NAME="dotfiles-test"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

build_image() {
  echo "🐳 Building Docker image..."
  docker build -t "$IMAGE_NAME" \
    --build-arg USER_UID="$(id -u)" \
    --build-arg USER_GID="$(id -g)" \
    "$DOTFILES_DIR"
}

run_container() {
  echo "🐳 Starting container (mount: $DOTFILES_DIR → ~/.dotfiles)"
  echo "   Run 'bash scripts/install.sh' to test installation"
  echo "   Type 'exit' to destroy the container"
  echo

  docker run -it --rm --init \
    --hostname dotfiles-test \
    -v "$DOTFILES_DIR:/home/ubuntu/.dotfiles" \
    "$IMAGE_NAME" \
    "${@:-bash}"
}

# Parse arguments
case "${1:-}" in
  --build)
    build_image
    ;;
  --run)
    build_image
    run_container bash -c "bash scripts/install.sh"
    ;;
  *)
    # Build if image doesn't exist
    if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
      build_image
    fi
    run_container
    ;;
esac