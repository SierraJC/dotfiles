# Remove greeting
set -U fish_greeting

# Use 256 color terminal
set -Ux COLORTERM truecolor

if status is-interactive
    # Enable vi key bindings
    set -U fish_key_bindings fish_vi_key_bindings
    # bind -M insert ctrl-e edit_command_buffer

    # starship init fish | source
    if type -q starship
        if not test -r $__fish_cache_dir/starship_init.fish
            starship init fish --print-full-init >$__fish_cache_dir/starship_init.fish
        end
        source $__fish_cache_dir/starship_init.fish
        enable_transience
    end

    # fzf --fish | source
    if type -q fzf
        set -Ux FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
        set -Ux FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -Ux FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

        if not test -r $__fish_cache_dir/fzf_init.fish
            fzf --fish >$__fish_cache_dir/fzf_init.fish
        end
        source $__fish_cache_dir/fzf_init.fish
    end

    # zoxide init --cmd cd fish | source
    if type -q zoxide
        if not test -r $__fish_cache_dir/zoxide_init.fish
            zoxide init --cmd cd fish >$__fish_cache_dir/zoxide_init.fish
        end
        source $__fish_cache_dir/zoxide_init.fish
    end
end
