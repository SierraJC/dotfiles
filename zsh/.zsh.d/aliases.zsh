alias zshconfig="$EDITOR $ZSH_CONFIG_DIR/exports.zsh"
alias zshalias="$EDITOR $ZSH_CONFIG_DIR/aliases.zsh $ZSH_CONFIG_DIR/aliases.local.zsh"
alias zshreload="source $HOME/.zshrc"

alias dotfiles='cd ~/.dotfiles'

# Edit git config in vscode
alias gcg="git config --edit --global"
alias gcl="git config --edit --local"

alias grep='grep --color=auto'
alias cls=clear

# Docker
alias dc="docker compose"
alias dcl="docker compose -f compose.local.yml"
alias dcd="docker compose -f compose.dev.yml"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# https://elijahmanor.com/blog/fd-fzf-tmux-nvim
alias v='fd --type f --hidden --exclude .git --exclude node_modules | fzf-tmux -p --reverse | xargs code'

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

backupfolder() { tar -zcvf "${1}_$(date '+%Y-%m-%d').tar.gz" "$1"; }

alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"

alias tf=terraform
alias tg=terragrunt
alias ap=ansible-playbook
alias ans=ansible
