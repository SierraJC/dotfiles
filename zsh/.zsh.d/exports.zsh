export PATH=$PATH:/usr/local/bin

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/bin

export VISUAL='code --wait'
export EDITOR='code --wait'

# Encoding stuff for the terminal
export LANG=en_AU.UTF-8
export LC_ALL=en_AU.UTF-8

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# DEFAULT_USER=$USER

# WSL
export SSH_SK_HELPER="/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe"

[ -f /etc/profile.d/golang_path.sh ] && source /etc/profile.d/golang_path.sh

# GitHub Copilot CLI
if command -v gh >/dev/null && gh extension list | grep -q 'copilot'; then
  eval "$(gh copilot alias -- zsh)"
  alias "??"="ghcs" # suggest
  alias "?"="ghce" # explain
fi

# NVM Paths
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# export NVM_DIR="$HOME/.nvm"
#   [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
#   [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Aliases that must load after PATH
# eval "$(github-copilot-cli alias -- "$0")"

# Not sure this is needed? called via plugin?
# eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# VSCode Internal Shell Integration
# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# pnpm
# export PNPM_HOME="/home/sierra/.local/share/pnpm"
# case ":$PATH:" in
# *":$PNPM_HOME:"*) ;;
# *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end

# # pyenv path
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
