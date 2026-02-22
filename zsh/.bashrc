# ? Executed for interactive shells
[[ $- != *i* ]] && return

_wezterm_sh="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/shell-integration.sh"
[[ -f "$_wezterm_sh" ]] && source "$_wezterm_sh"

# Drop into fish if:
# - The parent process isn't fish.
# - Not running a command like `bash -c 'echo foo'`.
# if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
#     # Let fish whether it's a login shell.
#     if ! shopt -q login_shell; then
#         exec fish --login
#     else
#         exec fish
#     fi
# fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd bash)"
fi
