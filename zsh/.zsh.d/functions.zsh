# Create a directory and cd into it
mcd() {
  mkdir -p "${1}" && cd "${1}"
}
alias mkcd=mcd

# Generate a random password of a given length.
# Copies to clipboard locally, prints to stdout in SSH sessions.
genpass() {
  length="${1:-16}"
  password=$(openssl rand -base64 $length | rev | cut -b 2- | rev)
  if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_CLIENT" ]]; then
    echo "$password"
  else
    echo "$password" | pbcopy >/dev/null 2>&1
    echo "Password copied to clipboard."
  fi
}

backupfolder() {
  tar -zcvf "${1}_$(date '+%Y-%m-%d').tar.gz" "$1"
}

command_exists() {
  command -v "$@" &>/dev/null
}

file_exists() {
  [ -f "$1" ]
}

dir_exists() {
  [ -d "$1" ]
}

# Shred and delete file
# dd f=/dev/random of="$1"
shredd() {
  shred -v -n 1 -z -u "$1"
}

tempe() {
  cd "$(mktemp -d)"
  chmod -R 700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
    chmod -R 700 .
  fi
}

mksh() {
  if [ ! $# -eq 1 ]; then
    echo 'mksh takes one argument' 1>&2
    exit 1
  elif [ -e "$1" ]; then
    echo "$1 already exists" 1>&2
    exit 1
  fi

  echo '#!/usr/bin/env bash
set -euo pipefail

' > "$1"

  chmod u+x "$1"

  "$EDITOR" "$1"
}