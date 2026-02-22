function __wezterm_set_user_var
    set -l encoded (printf "%s" $argv[2] | base64 | tr -d '\n')
    if test -z "$TMUX"
        printf "\033]1337;SetUserVar=%s=%s\007" $argv[1] $encoded
    else
        # <https://github.com/tmux/tmux/wiki/FAQ#what-is-the-passthrough-escape-sequence-and-how-do-i-use-it>
        # Note that you ALSO need to add "set -g allow-passthrough on" to your tmux.conf
        printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" $argv[1] $encoded
    end
end
