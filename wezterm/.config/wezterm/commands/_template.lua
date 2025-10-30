local wezterm = require 'wezterm'

local command = {
  brief = "<command name>",   -- A short description of the command
  icon = "md_circle_opacity", -- Material Design icon name
  action = wezterm.action_callback(function(window, pane)
    -- Example: Send "npm test" to the current pane and toggle background opacity
    window:perform_action(wezterm.action.SendString("npm test"), pane)

    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity or overrides.window_background_opacity == 1.0 then
      overrides.window_background_opacity = 0.8
      overrides.window_background_image = ""
    else
      overrides.window_background_opacity = 1.0
      -- overrides.window_background_image =
    end
  end)
}

return command
