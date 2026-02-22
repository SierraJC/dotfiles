local wezterm     = require 'wezterm'
local act         = wezterm.action
local mux         = wezterm.mux
local config      = wezterm.config_builder()

local constants   = require 'constants'
local commands    = require 'commands'
local plugins     = require 'plugins'
local keybindings = require 'keybindings'


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
	-- config.debug_key_events = true
end
debug_log_print()

config.default_prog =
		constants.is_macos and { '/opt/homebrew/bin/fish', '--login', '--interactive' }
		or constants.is_windows and { "pwsh.exe", "-NoLogo" }
		or nil

config.max_fps = constants.is_macos and 120 or 144
config.prefer_egl = true

config.font = wezterm.font("MesloLGS NF")
config.font_size = 12
config.line_height = 1.0
config.term = "xterm-256color"

config.window_decorations = "RESIZE"
config.adjust_window_size_when_changing_font_size = false
config.disable_default_key_bindings = false
config.pane_focus_follows_mouse = true

-- config.window_background_opacity = 0
-- config.win32_system_backdrop = "Acrylic" -- Mica / Tabbed
-- config.win32_acrylic_accent_color = COLOR

-- config.window_background_opacity = 0.9
config.macos_window_background_blur = 40

config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- MARK: Theme
config.color_scheme = "Catppuccin Mocha"
config.colors = wezterm.color.get_builtin_schemes()[config.color_scheme]

wezterm.on('window-config-reloaded', function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = appearance:find 'Dark' and 'Catppuccin Mocha' or 'Catppuccin Latte'
	wezterm.log_info("Appearance " .. appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		overrides.colors = wezterm.color.get_builtin_schemes()[scheme]
		window:set_config_overrides(overrides)
	end
end)

-- MARK: Tab Bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = false
config.default_workspace = "main"
config.window_close_confirmation = "AlwaysPrompt"
config.enable_scroll_bar = true
-- config.show_new_tab_button_in_tab_bar = false

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.64,
	brightness = 0.5
}

-- MARK: Keybindings
keybindings.apply_to_config(config)

-- MARK: Window Title
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
	local prefix = 'WezTerm'
	local workspace = mux.get_active_workspace()
	if workspace == 'default' then
		return prefix
	end
	return prefix .. ' - ' .. workspace
end)

-- MARK: Commands
wezterm.on("augment-command-palette", function()
	return commands
end)

-- MARK: Plugins
plugins.setup(config)

local scratch = '_quake'
wezterm.on("gui-attached", function(domain)
	local workspace = mux.get_active_workspace()
	if workspace ~= scratch then return end

	-- Compute width: 66% of screen width, up to 1000 px
	local width_ratio = 0.66
	local width_max = 1000
	local aspect_ratio = 16 / 9
	local screen = wezterm.gui.screens().active
	local width = math.min(screen.width * width_ratio, width_max)
	local height = width / aspect_ratio

	for _, window in ipairs(mux.all_windows()) do
		local guiWindow = window:gui_window()
		if guiWindow ~= nil then
			guiWindow:perform_action(act.SetWindowLevel "AlwaysOnTop", guiWindow:active_pane())
			guiWindow:set_inner_size(width, height)
		end
	end
end)

-- Tabline plugin is overriding my padding preference
config.window_padding = { left = 5, right = 5, top = 5, bottom = 5 }

wezterm.on('user-var-changed', function(window, pane, name, value)
	wezterm.log_info('var', name, value)
end)

return config
