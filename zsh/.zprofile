# ? Executed for login shells

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi
