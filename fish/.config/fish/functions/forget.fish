function forget \
    --description "Forget last command from history"

    # Use typed command, or fall back to most recent history item
    set -l cmd (commandline | string collect | string trim)
    test -z "$cmd"; and set cmd (history --max=1)
    test -z "$cmd"; and return

    # Prompt user for confirmation (default: yes)
    read -l -P "Forget '$cmd'? [Y/n] " reply
    # Only delete on explicit yes/y or empty (Enter)
    if string match -qir '^(y(es)?)?$' -- $reply
        history delete --exact --case-sensitive -- $cmd
        commandline ""
    end
    # Refresh the prompt
    commandline -f repaint
end