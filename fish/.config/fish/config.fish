# Remove greeting
set -U fish_greeting
set -Ux COLORTERM truecolor

if status is-interactive
    set -U fish_key_bindings fish_vi_key_bindings

    if type -q starship
        __cache_and_source starship_init.fish "starship init fish"
        enable_transience
    end

    if type -q fzf
        set -Ux FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
        set -Ux FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -Ux FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
        __cache_and_source fzf_init.fish "fzf --fish"
    end

    if type -q zoxide
        __cache_and_source zoxide_init.fish "zoxide init --cmd cd fish"
    end
end
