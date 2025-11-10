# __init__: Anything that needs to run first.

# Detect OS
set -q IS_MACOS; or test (uname) = Darwin; and set -U IS_MACOS

# Set XDG basedirs.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
set -q XDG_CONFIG_HOME; or set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -Ux XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -Ux XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME; or set -Ux XDG_CACHE_HOME $HOME/.cache
for xdgdir in (path filter -vd $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_STATE_HOME $XDG_CACHE_HOME)
    mkdir -p $xdgdir
end

# Allow subdirs for functions.
# set fish_function_path (path resolve $__fish_config_dir/functions/*/) $fish_function_path

# Setup caching.
if not set -q __fish_cache_dir
    if set -q XDG_CACHE_HOME
        set -U __fish_cache_dir $XDG_CACHE_HOME/fish
    else
        set -U __fish_cache_dir $HOME/.cache/fish
    end
end
test -d $__fish_cache_dir; or mkdir -p $__fish_cache_dir

# Remove expired cache files.
find $__fish_cache_dir -maxdepth 1 -name '*.fish' -type f -mmin +1200 -delete

# Setup homebrew.
if set -q IS_MACOS
    if not test -s $__fish_cache_dir/brew_init.fish
        if test -e /opt/homebrew/bin/brew
            /opt/homebrew/bin/brew shellenv >$__fish_cache_dir/brew_init.fish
        else if test -e /usr/local/bin/brew
            /usr/local/bin/brew shellenv >$__fish_cache_dir/brew_init.fish
        end
    end
    if test -e $__fish_cache_dir/brew_init.fish
        source $__fish_cache_dir/brew_init.fish
    end

    # Add fish completions
    if test -e "$HOMEBREW_PREFIX/share/fish/completions"
        set --append fish_complete_path "$HOMEBREW_PREFIX/share/fish/completions"
    end
    set -q HOMEBREW_NO_ANALYTICS || set -gx HOMEBREW_NO_ANALYTICS 1
end

# Add bin directories to path.
set -g prepath (
    path filter \
        $HOME/bin \
        $HOME/.local/bin \
        $HOME/go/bin
)
fish_add_path --prepend --move $prepath
