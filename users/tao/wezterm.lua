local wezterm = require 'wezterm';
local config = {
	font = wezterm.font 'FiraCode Nerd Font',
	color_scheme = 'GruvboxDarkHard',
	warn_about_missing_glyphs = false,
	check_for_updates = false,
	hide_tab_bar_if_only_one_tab = true,

	-- webgpu_power_preference = 'LowPower',
	-- front_end = 'WebGpu',
}

return config
