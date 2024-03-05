-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
if is_windows then
    config.default_domain = 'WSL:Ubuntu'

    local user = os.getenv("UserProfile")
    config.window_background_image = string.format("%s/wez_backgrounds/castle-background.jpg", user)
    -- wezterm.log_info(string.format("%s", user))

end

config.window_close_confirmation = "NeverPrompt"

config.color_scheme = 'Batman'
-- config.window_background_opacity = 0.90

config.window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = 0.1,
    -- You can adjust the hue by scaling its value.
    -- a multiplier of 1.0 leaves the value unchanged.
    hue = 0.5,
    -- You can adjust the saturation also.
    saturation = 2.0,
  }

config.keys = {
    { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain'},
  }

-- and finally, return the configuration to wezterm
return config
