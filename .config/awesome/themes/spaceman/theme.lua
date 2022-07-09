local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

local bgColor 		= "#191919"	-- dark gray
local pink	 	= "#D7859C"
local darkBlue		= "#FF4C35"	
local lightBlue		= "#3788A5"

theme.font		= "mononoki"

theme.bg_normal		= bgColor
theme.bg_focus		= darkBlue
theme.bg_urgent		= "#FF0000"
theme.bg_minimize	= "#444444"
theme.bg_systray	= bgColor

theme.fg_normal		= "#AAAAAA"
theme.fg_focus		= "#FFFFFF"
theme.fg_urgent		= "#FFFFFF"
theme.fg_minimize	= "#FFFFFF"

theme.useless_gap	= dpi(7)
theme.gap_single_client	= true
theme.border_width	= dpi(2)
theme.border_normal	= "#000000"
theme.border_focus	= pink
theme.border_marked	= lightBlue

theme.wallpaper		= "/usr/share/pixmaps/spaceman.jpeg"
theme.icon_theme	= nil

return theme
