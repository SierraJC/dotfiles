status is-interactive; or return

abbr cls " clear && printf '\e[3J'"
abbr c " clear && printf '\e[3J'"
abbr q " exit"

alias rm='rm -I'

abbr apt 'sudo apt'
abbr apt-get 'sudo apt-get'
abbr please ' please'
abbr pls ' please'

if type -q bat
    alias bat='bat --theme-dark "Catppuccin Mocha" --theme-light "Catppuccin Latte"'
    alias cat='bat --style=plain --paging=never'
    alias less='bat'
end

# Navigation
alias ls='ls --color=auto'
if type -q lsd
    alias ls='lsd --group-directories-first'
    alias tree='lsd --tree'
end

abbr -- - 'cd -'
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'
abbr ...... 'cd ../../../../..'
abbr cd.. 'cd ..'
abbr cd,, 'cd ..'
abbr lsa 'ls -lah'

abbr dotfiles 'cd ~/.dotfiles'

# Edit git config
abbr gcg 'git config --edit --global'
abbr gcl 'git config --edit --local'
abbr gcgl 'git config --edit --file ~/.gitconfig.local'
abbr gig '$EDITOR ~/.gitignore_global'
abbr gil '$EDITOR (git rev-parse --show-toplevel)/.git/info/exclude'
# Git
abbr -a --set-cursor='%' -- gcm 'git commit -m "%"'

# tmux
abbr tn 'tmux new-session -As'
abbr tl 'tmux list-sessions'
abbr ta 'tmux attach-session -t'

abbr lg lazygit

abbr mcd mkcd

# Claude CLI with better global mcp json
set -l claude_params '--mcp-config=$CLAUDE_CONFIG_DIR/.mcp.json --mcp-config=$CLAUDE_CONFIG_DIR/.mcp.local.json'
alias claude "claude $claude_params"
