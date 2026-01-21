abbr cls " clear && printf '\e[3J'"
abbr c " clear && printf '\e[3J'"
abbr q exit

abbr apt 'sudo apt'
abbr apt-get 'sudo apt-get'
abbr please ' please'
abbr pls ' please'

# Navigation
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
abbr gcgl 'git config --edit --file $HOME/.gitconfig.local'
abbr gig '$EDITOR ~/.gitignore_global'
# Git
abbr -a --set-cursor='%' -- gcm 'git commit -m "%"'

# tmux
abbr tn 'tmux new-session -As'
abbr tl 'tmux list-sessions'
abbr ta 'tmux attach-session -t'

abbr lg lazygit

abbr mcd mkcd

# Claude CLI with better global mcp json
set -l claude_params "--mcp-config=$HOME/.claude/.mcp.json --mcp-config=$HOME/.claude/.mcp.local.json"
if test -f $HOME/.local/bin/claude
    alias claude "$HOME/.local/bin/claude $claude_params"
else
    alias claude "claude $claude_params"
end
