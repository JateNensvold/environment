-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
if is_windows then
    config.default_domain = 'WSL:Ubuntu'
end

config.window_close_confirmation = "NeverPrompt"

-- and finally, return the configuration to wezterm
return config
