export PATH=$PATH:/usr/local/bin

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  export PATH=$PATH:$HOME/bin
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  export PATH=$PATH:$HOME/.local/bin
fi

DEFAULT_USER=$(whoami)

export SSH_SK_HELPER="/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe"

source /etc/profile.d/golang_path.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code --wait'
else
  export EDITOR='nano'
fi

# NVM Paths
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

## Golang
# if [ -d "/usr/local/go/bin" ]; then
#   export PATH=$PATH:/usr/local/go/bin
#   export PATH=$PATH:$HOME/go/bin
# fi

# Aliases that must load after PATH
eval $(thefuck --alias)
eval "$(github-copilot-cli alias -- "$0")"

# Change prompt
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n" # removed @%m (@hostname)
  fi
}
