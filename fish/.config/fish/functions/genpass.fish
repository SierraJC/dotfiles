function genpass \
    --description 'Generate a random password' \
    --argument-names length

    set -q argv[1]; and set length $argv[1]; or set length 16
    set password (openssl rand -base64 $length | rev | cut -b 2- | rev)
    if test -n "$SSH_CONNECTION" -o -n "$SSH_CLIENT"
        echo $password
    else
        echo $password | pbcopy >/dev/null 2>&1
        echo "Password copied to clipboard."
    end
end
