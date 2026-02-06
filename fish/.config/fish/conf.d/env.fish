set -gx DOTFILES $HOME/.dotfiles

# Set editor variables.
set -q PAGER; or set -gx PAGER less
set -q VISUAL; or set -gx VISUAL code
set -q EDITOR; or set -gx EDITOR nvim

set -q BROWSER; or set -gx BROWSER open

# Other vars
set -q FISH_THEME; or set -g FISH_THEME "catppuccin-mocha"
