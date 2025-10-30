local wezterm = require('wezterm')
local constants = require('constants')
local act = wezterm.action

local M = {}

function M.apply_to_config(config)
	config.leader = { key = '`', mods = nil, timeout_milliseconds = 1500 }
	config.keys = {
		{
			key = config.leader.key,
			mods = 'LEADER|' .. (config.leader.mods or ''),
			action = act.SendKey { key = config.leader.key, mods = config.leader.mods },
		},
		{
			key = 'c',
			mods = 'CTRL',
			action = wezterm.action_callback(function(window, pane)
				if window:get_selection_text_for_pane(pane) ~= '' then
					window:perform_action(act.CopyTo('Clipboard'), pane)
					window:perform_action(act.ClearSelection, pane)
				else
					window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
				end
			end),
		},
		{ key = 'v',     mods = 'CTRL',         action = act.PasteFrom('Clipboard') }, -- Required for Voice-to-text apps
		-- { key = ' ',     mods = 'LEADER', action = act.ActivateCommandPalette },
		{ key = 'Enter', mods = 'SHIFT',        action = 'QuickSelect' },
		{ key = 'Enter', mods = 'ALT',          action = act.Nop },
		{ key = 't',     mods = 'CTRL',         action = act.ShowLauncherArgs { flags = 'FUZZY|DOMAINS' } },
		{ key = 'w',     mods = 'CTRL',         action = act.CloseCurrentPane { confirm = true } },

		-- Tmux style keybindings
		-- Multiplexer
		{ key = 'a',     mods = 'LEADER',       action = act.AttachDomain(constants.is_macos and 'unix' or 'SSHMUX:work') },
		{ key = 'd',     mods = 'LEADER',       action = act.DetachDomain('CurrentPaneDomain') },

		-- Workspace (Session)
		{ key = 's',     mods = 'LEADER',       action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },

		-- Tab (Window)
		{ key = 'c',     mods = 'LEADER',       action = act.SpawnTab('CurrentPaneDomain') },
		{ key = '1',     mods = 'LEADER',       action = act.ActivateTab(0) },
		{ key = '2',     mods = 'LEADER',       action = act.ActivateTab(1) },
		{ key = '3',     mods = 'LEADER',       action = act.ActivateTab(2) },
		{ key = '4',     mods = 'LEADER',       action = act.ActivateTab(3) },
		{ key = '5',     mods = 'LEADER',       action = act.ActivateTab(4) },
		{ key = '6',     mods = 'LEADER',       action = act.ActivateTab(5) },
		{ key = '7',     mods = 'LEADER',       action = act.ActivateTab(6) },
		{ key = '8',     mods = 'LEADER',       action = act.ActivateTab(7) },
		{ key = '9',     mods = 'LEADER',       action = act.ActivateTab(-1) },
		{ key = 'Tab',   mods = 'LEADER',       action = act.ActivateTabRelative(1) },
		{ key = 'Tab',   mods = 'LEADER|SHIFT', action = act.ActivateTabRelative(-1) },
		{ key = 'w',     mods = 'LEADER',       action = act.ShowTabNavigator },
		-- Key table for moving tabs around
		{
			key = '.',
			mods = 'LEADER',
			action = act.ActivateKeyTable { name = 'move_tab', one_shot = false, timeout_milliseconds = 3000 },
		},
		-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
		--{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
		--{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
		{
			-- Rename Tab
			key = ',',
			mods = 'LEADER',
			action = act.PromptInputLine {
				description = wezterm.format {
					{ Attribute = { Intensity = 'Bold' } },
					{ Foreground = { AnsiColor = 'Fuchsia' } },
					{ Text = 'Renaming Tab Title...:' },
				},
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			},
		},

		-- Pane
		{ key = 'h',          mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
		{ key = 'j',          mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
		{ key = 'k',          mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
		{ key = 'l',          mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
		{ key = 'LeftArrow',  mods = 'CTRL',   action = act.ActivatePaneDirection('Left') },
		{ key = 'RightArrow', mods = 'CTRL',   action = act.ActivatePaneDirection('Right') },
		{ key = 'UpArrow',    mods = 'CTRL',   action = act.ActivatePaneDirection('Up') },
		{ key = 'DownArrow',  mods = 'CTRL',   action = act.ActivatePaneDirection('Down') },
		-- { key = ' ', mods = 'LEADER', action = act.RotatePanes('Clockwise') },
		-- { key = " ",     mods = "LEADER", action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" } },
		{ key = 'z',          mods = 'LEADER', action = act.TogglePaneZoomState },
		{ key = 'x',          mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
		{ key = 'h',          mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
		{ key = 'v',          mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
		{ key = 'p',          mods = 'LEADER', action = act.PaneSelect },
		-- Resize pane key table
		{
			key = 'r',
			mods = 'LEADER',
			action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, timeout_milliseconds = 3000 },
		},
		{
			-- Move Pane to New Tab
			key = '!',
			mods = 'LEADER | SHIFT',
			action = wezterm.action_callback(function(win, pane)
				pane:move_to_new_tab()
			end),
		},
	}

	config.mouse_bindings = {
		-- Ctrl-click to open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = 'Left' } },
			mods = 'CTRL',
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	}

	config.key_tables = {
		resize_pane = {
			{ key = 'h',      action = act.AdjustPaneSize { 'Left', 1 } },
			{ key = 'j',      action = act.AdjustPaneSize { 'Down', 1 } },
			{ key = 'k',      action = act.AdjustPaneSize { 'Up', 1 } },
			{ key = 'l',      action = act.AdjustPaneSize { 'Right', 1 } },
			{ key = 'Escape', action = 'PopKeyTable' },
			{ key = 'Enter',  action = 'PopKeyTable' },
		},
		move_tab = {
			{ key = 'h',      action = act.MoveTabRelative(-1) },
			{ key = 'j',      action = act.MoveTabRelative(-1) },
			{ key = 'k',      action = act.MoveTabRelative(1) },
			{ key = 'l',      action = act.MoveTabRelative(1) },
			{ key = 'Escape', action = 'PopKeyTable' },
			{ key = 'Enter',  action = 'PopKeyTable' },
		},
	}
end

return M
