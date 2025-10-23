export ZDOTDIR=$HOME
# export ZDOTDIR="${XDG_CONFIG_HOME}/zsh" # hmmmm
# export ZRCDIR="${ZHOMEDIR}/zsh.d"

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# For macOS, this must be set here instead of in exports due to plugins needing brew bins
[ -f "/opt/homebrew/bin/brew" ] && {
  export HOMEBREW_NO_ANALYTICS=1
  eval "$(/opt/homebrew/bin/brew shellenv)"
}