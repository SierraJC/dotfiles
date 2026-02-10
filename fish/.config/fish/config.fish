# Remove greeting
set -g fish_greeting
set -gx COLORTERM truecolor

if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
    # fish_config theme choose Catppuccin --color-theme=dark

    if type -q mise
        __cache_and_source mise_init.fish "mise activate fish"
    end

    if type -q starship
        __cache_and_source starship_init.fish "starship init fish --print-full-init"
        enable_transience
    end

    if type -q fzf
        set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
        __cache_and_source fzf_init.fish "fzf --fish"
    end

    if type -q zoxide
        __cache_and_source zoxide_init.fish "zoxide init --cmd cd fish"
    end
end


