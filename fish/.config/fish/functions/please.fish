function please \
    --description 'Politely run command with sudo'

    if test (count $argv) -gt 0
        sudo $argv
    else
        eval sudo $history[1]
    end
end
