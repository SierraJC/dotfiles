# WezTerm shell integration for fish.
#
# OSC 7 (CWD reporting) and OSC 133 (semantic zones) are handled
# natively by fish 4.0+. This file provides OSC 1337 user variables:
#   WEZTERM_PROG, WEZTERM_USER, WEZTERM_HOST, WEZTERM_IN_TMUX
#
# Ported from: https://github.com/wezterm/wezterm/blob/main/assets/shell-integration/wezterm.sh

if set -q "$WEZTERM_SHELL_SKIP_ALL" = 1; or set -q "$WEZTERM_SHELL_SKIP_USER_VARS" = 1
    exit
end

# Static vars — these don't change within a session, so set them once.
__wezterm_set_user_var WEZTERM_USER (set -q USER; and echo $USER; or id -un)
__wezterm_set_user_var WEZTERM_IN_TMUX (set -q TMUX; and echo 1; or echo 0)

if set -q hostname
    __wezterm_set_user_var WEZTERM_HOST $hostname
else if set -q WEZTERM_HOSTNAME
    __wezterm_set_user_var WEZTERM_HOST $WEZTERM_HOSTNAME
else if test -r /proc/sys/kernel/hostname
    __wezterm_set_user_var WEZTERM_HOST (command cat /proc/sys/kernel/hostname)
else if type -q hostname
    __wezterm_set_user_var WEZTERM_HOST (hostname)
else if type -q hostnamectl
    __wezterm_set_user_var WEZTERM_HOST (hostnamectl hostname)
else
    __wezterm_set_user_var WEZTERM_HOST unknown
end

# Dynamic vars — WEZTERM_PROG tracks the currently running command.
function __wezterm_user_vars_precmd --on-event fish_prompt
    __wezterm_set_user_var WEZTERM_PROG ""
end

function __wezterm_user_vars_preexec --on-event fish_preexec
    __wezterm_set_user_var WEZTERM_PROG $argv[1]
end
