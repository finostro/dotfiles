-- Pull in the wezterm API
local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- if you want to use separate direction keys for move vs. resize, you
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})
-- and finally, return the configuration to wezterm
return config
