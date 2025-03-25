# Encoding stuff for the terminal
export LANGUAGE="en_AU.UTF-8"
export LANG="$LANGUAGE"
export LC_ALL="$LANGUAGE"
export LC_CTYPE="$LANGUAGE"

export DOTFILES="$HOME/.dotfiles"
export WORKSPACE="$HOME/dev"

if command_exists code; then
  export EDITOR="code --wait"
else
  export EDITOR="nano"
fi
export VISUAL="$EDITOR"

# Enable history so we get auto suggestions
export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history" # History filepath
export HISTSIZE=100000                           # Maximum events remembered for internal history
export SAVEHIST=$HISTSIZE                        # Maximum events stored in history file
