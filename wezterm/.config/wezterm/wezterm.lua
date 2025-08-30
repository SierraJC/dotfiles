local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local is_macos = wezterm.target_triple == 'aarch64-apple-darwin'
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

local function debug_log_print()
  --wezterm.log_info("Default hyperlink rules " .. wezterm.default_hyperlink_rules())
  --wezterm.log_info("Default ssh domains" .. wezterm.default_ssh_domains())
  --wezterm.log_info("Default wsl domains" .. wezterm.default_wsl_domains())
  wezterm.log_info("Config Dir " .. wezterm.config_dir)
  wezterm.log_info("Config file " .. wezterm.config_file)
  wezterm.log_info("Version " .. wezterm.version)
  wezterm.log_info("Exe dir " .. wezterm.executable_dir)
  wezterm.log_info("Hostname " .. wezterm.hostname())
  wezterm.log_info("Running under wsl" .. tostring(wezterm.running_under_wsl()))
  config.debug_key_events = true
end

config.initial_cols = 80
-- config.initial_rows = 28


config.max_fps = 120
config.animation_fps = 120

config.font = wezterm.font("MesloLGS NF")
config.font_size = 10
config.line_height = 1

config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 20

config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32
-- config.show_new_tab_button_in_tab_bar = false

-- MARK: Theme
config.color_scheme = wezterm.gui.get_appearance():find("Dark") and "Catppuccin Mocha" or "Catppuccin Latte"
config.colors = wezterm.color.get_builtin_schemes()[config.colors]


-- MARK: OS

if is_windows then
  -- config.default_prog = { "powershell.exe", "-NoLogo" }
end

if is_macos then
  -- config.default_prog = { "zsh" }
end

wezterm.on("gui-startup", function(cmd)
  -- Pick the active screen to maximize into, there are also other options, see the docs.
  local active = wezterm.gui.screens().active

  -- Set the window coords on spawn.
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {
    x = active.x,
    y = active.y,
    width = active.width,
    height = active.height,
  })

  -- You probably don't need both, but you can also set the positions after spawn.
  window:gui_window():set_position(active.x, active.y)
  window:gui_window():set_inner_size(active.width, active.height)
end)

debug_log_print()

return config