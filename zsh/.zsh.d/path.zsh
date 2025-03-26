export PATH=$PATH:/usr/local/bin

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/bin

# WSL
# export SSH_SK_HELPER="/mnt/c/Program Files/OpenSSH/ssh-sk-helper.exe"

if command_exists go; then
  # File created by `update-golang` project
  file_exists "/etc/profile.d/golang_path.sh" && source /etc/profile.d/golang_path.sh || {
    export PATH=$PATH:/usr/local/go/bin
  }
fi

# NVM Paths
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export NVM_DIR="$HOME/.nvm"
#   [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
#   [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# UV / Python
[ -s "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"

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
