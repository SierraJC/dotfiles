function magic-enter-cmd --description "Command to run when pressing enter on an empty prompt"
    set --local cmd ls -laF

    if command git rev-parse --is-inside-work-tree &>/dev/null
        set cmd git status -sb
    end

    # Output as tokens (one per line) so command substitution returns a proper argv list.
    printf '%s\n' $cmd
end

function magic-enter
    set -l cmd (commandline)
    if test -z "$cmd"
        # Run the magic command directly so it doesn't get recorded in history.
        set -l magic_cmd (magic-enter-cmd)
        commandline -f suppress-autosuggestion
        printf '\n'
        $magic_cmd
        commandline -f repaint
        return
    end
    commandline -f execute
end

function magic-enter-bindings --description "Bind magic-enter for default and vi key bindings"
    bind \r magic-enter
    if functions -q fish_vi_key_bindings
        bind -M insert \r magic-enter
        bind -M default \r magic-enter
    end
end
magic-enter-bindings
