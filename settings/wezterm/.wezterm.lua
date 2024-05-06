-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()


-- utility functions
local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
	return wezterm.target_triple:find("windows") ~= nil
end

local is_unix = function()
	return is_linux() or is_darwin()
end

-- This is where you actually apply your config choices
if is_windows() then
	config.default_domain = "WSL:Ubuntu"

	local user = os.getenv("UserProfile")
	-- use multiple wezterm backgrounds
	-- https://github.com/KevinSilvester/wezterm-config

	-- config.window_background_image = string.format("%s/wez_backgrounds/castle-background.jpg", user)
	config.window_background_image = string.format("%s/wez_backgrounds/smoke-1178319.jpg", user)
elseif is_unix() then
	local user = os.getenv("HOME")
	config.window_background_image = string.format("%s/environment/settings/wezterm/backgrounds/smoke-1178319.jpg", user)
end

print(config.window_background_image)

config.window_close_confirmation = "NeverPrompt"

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
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
				window:perform_action("ClearSelection", pane)
			else
				window:perform_action(wezterm.action({ SendKey = { key = "c", mods = "CTRL" } }), pane)
			end
		end),
	},
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ SendKey = { key = "c", mods = "CTRL" } }) },
	{ key = "v", mods = "CTRL",       action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "v", mods = "CTRL",       action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ SendKey = { key = "v", mods = "CTRL" } }) },
}

-- and finally, return the configuration to wezterm
return config
