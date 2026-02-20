# ? Executed for interactive shells
[[ ! -o interactive ]] && return

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

source $HOME/.zshrc.local

# Anything below here was probably added automatically and should be re-adjusted or moved to ~/.zshrc.local
