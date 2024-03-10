alias zshconfig="$EDITOR $ZLIB/custom.zsh"
alias zshalias="$EDITOR $ZLIB/aliases.zsh"
alias zshreload="source $ZDOTDIR/.zshrc"

# Edit git config in vscode
alias gcg="git config --edit --global"
alias gcl="git config --edit --local"

alias e=pico
alias g=git
alias y=yadm
alias dc=docker-compose
alias grep='grep --color=always'
alias cls=clear

# sudoify
alias apt='sudo apt'

alias \
  cd..='cd ..' \
  cd,,=cd.. \
  ..='cd ..' \
  ...='cd ../..' \
  ....='cd ../../..' \
  .....='cd ../../../..' \
  ......='cd ../../../../..'

alias pn=pnpm
alias goupdate="sudo $HOME/update-golang/update-golang.sh"

# Untar gzip.
alias untarz="tar -xvzf"
# Untar bzip2.
alias untarb="tar -xvjf"
# Untar xz.
alias untarx="tar -xvJf"

alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"

# Thefuck
eval $(thefuck --alias)

# GitHub Copilot CLI
eval "$(github-copilot-cli alias -- "$0")"
