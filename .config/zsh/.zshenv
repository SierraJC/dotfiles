#
#  ~/.zshenv
#             _
#     ___ ___| |_ ___ ___ _ _
#   _|- _|_ -|   | -_|   | | |
#  |_|___|___|_|_|___|_|_|\_/
#

# Set default applications.
export EDITOR="code -r"

# Set XDG base directories.
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_BIN_HOME="${HOME}/.local/bin"
export XDG_LIB_HOME="${HOME}/.local/lib"
export XDG_CACHE_HOME="${HOME}/.cache"

# Respect XDG directories.
#export GNUPGHOME="${XDG_DATA_HOME}/gnupg" # This breaks gpg-agent.
# export KDEHOME="${XDG_CONFIG_HOME}/kde"
# export LESSHISTFILE="-" # Disable less history.

export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_DATA_HOME}/pip/log"
# export CARGO_HOME="${XDG_DATA_HOME}/cargo"
# export VIMINIT=":source $XDG_CONFIG_HOME/vim/vimrc"
#export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority" # This breaks SDDM.
# export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
# export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZLIB="${ZDOTDIR}/lib"
# Check if Docker daemon is running in rootless mode.
# docker_status=$(systemctl --user is-active docker 2>&1)
# if [[ "$docker_status" == "active" ]]; then
#     export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
#     export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
# fi

# Add custom paths.
# [ -d "${XDG_BIN_HOME}" ] && PATH="${PATH}:${XDG_BIN_HOME}" && export PATH
# [ -d "${HOME}/.config/autostart-scripts" ] && PATH="${PATH}:${HOME}/.config/autostart-scripts" && export PATH
