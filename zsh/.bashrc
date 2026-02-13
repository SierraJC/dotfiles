# ? Executed for interactive shells

# guard against non-interactive shells
[[ $- != *i* ]] && return

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
