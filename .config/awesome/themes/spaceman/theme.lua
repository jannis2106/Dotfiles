local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears_shape = require("gears.shape")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local taglistShape = function(cr, width, height)
    gears_shape.rounded_rect(cr, width, height, 4)
end

local theme = {}

local bgColor 		= "#191919"	-- dark gray
local accent 	    = "#e95678" -- red

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

theme.taglist_shape = taglistShape 

theme.wallpaper		= "/usr/share/pixmaps/spaceman.jpeg"
theme.icon_theme	= nil

theme.icon_size     = 16
theme.icon_color    = theme.fg_normal

return theme
