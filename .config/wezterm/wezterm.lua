local wezterm = require("wezterm")
local config = {}

config.font_size = 15
config.window_background_opacity = 0.90
config.macos_window_background_blur = 92
config.text_background_opacity = 1

config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("IBM Plex Mono")

config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

-- Native macOS fullscreen (own Space, animated slide) instead of WezTerm's
-- default snap-over-the-screen fullscreen. Matches how Ghostty transitions.
config.native_macos_fullscreen_mode = true

-- Glassy 1px hairline so the window edge reads against a black wallpaper.
-- Always on, even in fullscreen -- toggling it per-state caused a visible
-- flash during the transition. Raise the alpha if it's too subtle. NOTE:
-- applied at window creation, so changes here need a new window (Cmd-N),
-- not just a config reload.
local border_color = "rgba(230, 201, 168, 0.40)"  -- foreground e6c9a8, glassy
config.window_frame = {
  border_left_width = "2px",
  border_right_width = "2px",
  border_top_height = "2px",
  border_bottom_height = "2px",
  border_left_color = border_color,
  border_right_color = border_color,
  border_top_color = border_color,
  border_bottom_color = border_color,
}

-- make the cursor not blink
config.cursor_blink_rate = 0

-- start up dimensions (to make it full screen)
-- config.initial_rows = 100
-- config.initial_cols = 200

config.colors = {
  foreground = "e6c9a8",
  background = "#000000",   -- black terminal background

  -- tab bar (flat, same shade as the terminal background)
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

config.keys = {
  -- unbind minimize with command-M cause i only ever do it by accident
  { key = "m", mods = "CMD", action = wezterm.action.Nop },

  -- Deliberately NOT translating Opt-Backspace / Cmd-Backspace into Ctrl-W /
  -- Ctrl-U. The terminal is its own world: delete-word and delete-line are
  -- Ctrl-W and Ctrl-U here, which zsh and nvim already bind natively.
  -- Everywhere else it's the reverse. Two worlds with one rule each beats one
  -- leaky rule everywhere.
  --
  -- The two halves fail for different reasons, which is worth keeping straight:
  --   Opt-Backspace does NOT work in this shell, contrary to what the
  --   emacs-mode readline default would suggest. Alt has a wire encoding (the
  --   ESC prefix), so it arrives as ESC DEL -- but .zshrc sets `bindkey -v`
  --   with KEYTIMEOUT=1, and in viins `^[` is vi-cmd-mode, resolved instantly.
  --   So the ESC half is eaten as a mode switch and `^[^?` is never bound at
  --   all. `^W` (bound explicitly in .zshrc) is the only backward-kill-word
  --   in here. nvim ignores Opt-Backspace too, for its own reasons.
  --   Cmd-Backspace can NEVER work in any terminal. The legacy key encoding
  --   has bits for Shift/Alt/Ctrl and nothing for Cmd, so WezTerm drops the
  --   modifier and sends a bare DEL -- kanata's Ctrl-Cmd-H deletes one
  --   character in here and a whole line everywhere else. Not a config bug;
  --   the modifier is lost downstream of kanata. (The kitty keyboard protocol
  --   can express Super, but both ends have to opt in, and TUIs here don't.)
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

