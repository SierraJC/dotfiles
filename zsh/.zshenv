# ? Executed for all shells

export LANG="en_AU.UTF-8"
export LC_ALL="en_AU.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HOMEBREW_NO_ANALYTICS=1

# Disable Apple's save/restore mechanism.
export SHELL_SESSIONS_DISABLE=1

export EDITOR="nvim"
export VISUAL="$EDITOR"

if [[ -n "$SSH_CONNECTION" ]]; then
  export BROWSER="open-browser"
fi
