# Enable the native Zsh completion system
# Cache completions aggressively
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# Set up fzf key bindings and fuzzy completion
command_exists fzf && eval "$(fzf --zsh)"

# VSCode Internal Shell Integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Not sure this is needed? called via plugin?
# eval "$(zoxide init zsh)"

command_exists uv && {
  # Enable autocompletion for `uv` commands
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
}
