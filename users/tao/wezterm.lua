local wezterm = require 'wezterm';
local config = {
	font = wezterm.font 'FiraCode Nerd Font',
	color_scheme = 'Dracula',
	warn_about_missing_glyphs = true,
	check_for_updates = false,
	hide_tab_bar_if_only_one_tab = true,
}
return config
