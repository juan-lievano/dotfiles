local wezterm = require("wezterm")
local config = {}

config.font_size = 16.5
config.window_background_opacity = 0.90
config.macos_window_background_blur = 92
config.text_background_opacity = 1

config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("IBM Plex Mono")

config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

-- make the cursor not blink
config.cursor_blink_rate = 0

-- start up dimensions (to make it full screen)
-- config.initial_rows = 100
-- config.initial_cols = 200

config.colors = {
  foreground = "e6c9a8",
  background = "#000000",   -- black terminal background

  -- tab bar (flat)
  tab_bar = {
    background = "#000000",
    active_tab =   { bg_color = "#000000", fg_color = "e6c9a8", intensity = "Bold" },
    inactive_tab = { bg_color = "#000000", fg_color = "#888888" },
    inactive_tab_hover = { bg_color = "#111111", fg_color = "#FFFFFF" },
    new_tab =      { bg_color = "#000000", fg_color = "#666666" },
    new_tab_hover ={ bg_color = "#111111", fg_color = "#FFFFFF" },
  },
}
config.hide_tab_bar_if_only_one_tab = true

-- unbind minimize with command-M cause i only ever do it by accident
config.keys = {
  { key = "m", mods = "CMD", action = wezterm.action.Nop },
}

-- show clear difference between focused and unfocused window

wezterm.on("window-focus-changed", function(window, _pane)
  local overrides = window:get_config_overrides() or {}

  if window:is_focused() then
    -- Remove overrides so it uses your base config (0.65 opacity)
    overrides.window_background_opacity = nil
  else
    -- Much more transparent when unfocused
    overrides.window_background_opacity = 0.40
  end

  window:set_config_overrides(overrides)
end)

return config

