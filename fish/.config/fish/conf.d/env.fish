set -gx DOTFILES $HOME/.dotfiles

# Set editor variables.
set -q PAGER; or set -Ux PAGER less
set -q VISUAL; or set -Ux VISUAL code
set -q EDITOR; or set -Ux EDITOR nvim

set -q BROWSER; or set -Ux EDITOR open

# Other vars
set -q FISH_THEME; or set -U FISH_THEME "Catppuccin Mocha"
