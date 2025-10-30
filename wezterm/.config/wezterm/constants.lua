local wezterm = require 'wezterm'
local M       = {}

local home    = os.getenv 'HOME' or os.getenv 'USERPROFILE'

M.bg_image    = home .. "/dotfiles/wezterm/assets/bg.png"

M.is_macos    = wezterm.target_triple == 'aarch64-apple-darwin'
M.is_windows  = wezterm.target_triple == 'x86_64-pc-windows-msvc'
M.is_linux    = not M.is_macos and not M.is_windows

return M
