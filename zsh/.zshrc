# ? Executed for interactive shells
[[ ! -o interactive ]] && return

local _wezterm_sh="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/shell-integration.sh"
[[ -f "$_wezterm_sh" ]] && source "$_wezterm_sh"

# Auto-cd if the command is a directory and can't be executed as a normal command.
setopt auto_cd

# When deleting with <C-w>, delete file names at a time.
WORDCHARS=${WORDCHARS/\/}

# Functions for completion sources.
# fpath=($ZDOTDIR/func $fpath)
fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
autoload -Uz compinit
compinit

# Use a completion menu.
zstyle ':completion:*' menu select

# Execute fish if it's not the parent process.
# if ! ps -p $PPID | grep -q fish; then
#   exec fish
# fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

alias q='exit'
alias cls='clear && printf "\e[3J"'
alias c='cls'

source $HOME/.zshrc.local

# Anything below here was probably added automatically and should be re-adjusted or moved to ~/.zshrc.local
