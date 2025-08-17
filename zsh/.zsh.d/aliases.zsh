alias zshconfig="$EDITOR $ZDOTDIR/.zshrc.local"
alias zshalias="$EDITOR $ZSH_CONFIG_DIR/aliases.zsh $ZSH_CONFIG_DIR/aliases.local.zsh"
alias zshreload="source $HOME/.zshrc"

alias dotfiles="cd $DOTFILES"

# Edit git config in vscode
alias gcg="git config --edit --global"
alias gcl="git config --edit --local"
alias gcgl="git config --edit --file $HOME/.gitconfig.local"

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

alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"

alias tf=terraform
alias tg=terragrunt
alias ap=ansible-playbook
alias ans=ansible

# GitHub Copilot CLI
if command_exists gh && gh extension list | grep -q 'copilot'; then
  eval "$(gh copilot alias -- zsh)"
  alias "??"="ghcs" # suggest
  alias "?"="ghce" # explain
fi

# Claude Code
if command_exists claude; then
  alias claude="claude --verbose --mcp-config ~/.claude/.mcp.json"
fi
