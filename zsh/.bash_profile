# ? Executed for login shells

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv bash)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash --shims)"
fi

# If the shell is interactive, source the .bashrc file
if [[ $- == *i* ]] && [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi