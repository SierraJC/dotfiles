export LANG="en_AU.UTF-8"
export LC_ALL="en_AU.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export PATH="$HOME/bin:$HOME/.local/bin:$XDG_DATA_HOME/bin:$PATH"

export EDITOR="nvim"
export VISUAL="$EDITOR"


if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv bash)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

if [[ $- != *i* ]]; then
  # ? Non-interactive shell
  command -v mise >/dev/null 2>&1 && \
    eval "$(mise activate bash --shims)"
  return
fi

# ? Interactive shell

# Drop into fish if:
# - The parent process isn't fish.
# - Not running a command like `bash -c 'echo foo'`.
# - The shell level is 1, which means it's the initial login shell.
if command -v fish >/dev/null 2>&1 && [[ $(basename "$(ps -p $PPID -o comm=)") != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
    # Let fish whether it's a login shell.
    if ! shopt -q login_shell; then
        exec fish --login
    else
        exec fish
    fi
fi

_wezterm_sh="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/shell-integration.sh"
[[ -f "$_wezterm_sh" ]] && source "$_wezterm_sh"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd bash)"
fi

alias q='exit'
alias cls='clear && printf "\e[3J"'
alias c='cls'

# Don't put duplicate entries or entries starting with space in the history.
HISTCONTROL=ignorespace:ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE

# bash-preexec (bundled with wezterm's shell integration) forcibly strips
# ignorespace from HISTCONTROL so it can read space-prefixed commands via
# `history 1` for its preexec hooks. This is an unresolved upstream issue:
# https://github.com/rcaloras/bash-preexec/issues/115
__bp_adjust_histcontrol() { :; }
