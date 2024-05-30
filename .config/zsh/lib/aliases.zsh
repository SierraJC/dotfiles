alias zshconfig="$EDITOR $ZLIB/1-custom.zsh"
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
alias apt-get='sudo apt-get'

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

# Docker
alias dc="docker compose"
alias dcl="docker compose -f compose.local.yml"
alias dcd="docker compose -f compose.dev.yml"

alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"
