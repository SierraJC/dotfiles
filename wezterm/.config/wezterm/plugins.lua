local wezterm = require 'wezterm'

local M = {}

function M.setup(config)
  local KEY_TABLE_LABELS = {
    resize_pane = "RESIZE",
    move_tab = "MOVE",
  }

  local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
  tabline.setup({
    options = {
      icons_enabled = true,
      theme = config.color_scheme,
      tabs_enabled = true,
      theme_overrides = {},
      section_separators = {
        left = wezterm.nerdfonts.pl_left_hard_divider,
        right = wezterm.nerdfonts.pl_right_hard_divider,
      },
      component_separators = {
        left = wezterm.nerdfonts.pl_left_soft_divider,
        right = wezterm.nerdfonts.pl_right_soft_divider,
      },
      tab_separators = {
        left = wezterm.nerdfonts.pl_left_hard_divider,
        right = wezterm.nerdfonts.pl_right_hard_divider,
      },
    },
    sections = {
      tabline_a = {
        {
          'mode',
          fmt = function(mode, window)
            if window:leader_is_active() then
              return wezterm.format { { Text = "LEADER" } }
            else
              local key_table = window:active_key_table()
              if key_table then
                local label = KEY_TABLE_LABELS[key_table] or key_table:upper()
                return wezterm.format { { Text = label } }
              end
            end
            return mode
          end,
        },
      },
      tabline_b = {},
      tabline_c = { ' ' },
      tab_active = {
        'index',
        { 'parent', padding = 0 },
        '/',
        { 'cwd',    padding = { left = 0, right = 1 } },
        { 'zoomed', padding = 0 },
      },
      tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
      tabline_x = { 'ram', 'cpu' },
      tabline_y = { 'battery' },
      tabline_z = { { 'domain', icons_only = true } },
    },
    extensions = {},
  })
  tabline.apply_to_config(config)
end

return M
