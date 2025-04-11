# Create a directory and cd into it
mcd() {
  mkdir -p "${1}" && cd "${1}"
}

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
