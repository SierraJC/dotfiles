# Create a directory and cd into it
mcd() {
    mkdir -p "${1}" && cd "${1}"
}

# Generate a random password of a given length, copy to clipboard
genpass(){
    length="${1:-16}"
    openssl rand -base64 $length | rev | cut -b 2- | rev | pbcopy >/dev/null 2>&1
}