local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

local bgColor 		= "#191919"	-- dark gray
local accent 	    = "#e95678"

theme.font		    = "mononoki"

theme.bg_normal		= bgColor
theme.bg_focus		= accent
theme.bg_urgent		= accent
theme.bg_minimize	= "#444444"
theme.bg_systray	= bgColor

theme.fg_normal		= "#AAAAAA"
theme.fg_focus		= bgColor
theme.fg_urgent		= "#FFFFFF"
theme.fg_minimize	= "#FFFFFF"

theme.useless_gap	= dpi(7)
theme.gap_single_client	= true
theme.border_width	= dpi(2)
theme.border_normal	= "#000000"
theme.border_focus	= accent
theme.border_marked	= accent

theme.wallpaper		= "/usr/share/pixmaps/spaceman.jpeg"
theme.icon_theme	= nil

theme.icon_size     = 16
theme.icon_font     = "Mononoki Nerd Font " -- attention to space at the end!
theme.icon_color    = theme.fg_normal

return theme
