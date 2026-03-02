function magic-enter --description "Run a default command on empty Enter"
    if test -n (commandline)
        commandline -f execute
        return
    end

    set -l cmd 'ls -lahF'
    #if command git rev-parse --is-inside-work-tree &>/dev/null
    #   set cmd 'git status -sb'
    #end

    commandline -r $cmd
    commandline -f suppress-autosuggestion
    commandline -f execute
end

function __magic_enter_bind --description "Bind magic-enter to Enter key"
    bind \r magic-enter
    bind -M insert \r magic-enter
    bind -M default \r magic-enter
end

status is-interactive; and __magic_enter_bind
