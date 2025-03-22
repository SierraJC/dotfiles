# Create a directory and cd into it
mcd() {
  mkdir -p "${1}" && cd "${1}"
}

# Generate a random password of a given length, copy to clipboard
genpass() {
  length="${1:-16}"
  openssl rand -base64 $length | rev | cut -b 2- | rev | pbcopy >/dev/null 2>&1
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
