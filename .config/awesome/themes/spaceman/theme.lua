local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shape = require("gears.shape")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local taglistShape = function(cr, width, height)
    shape.transform(shape.rounded_rect) : translate(0, 25) (cr, width, height, 4)
end

local hotkeysShape = function(cr, width, height)
    shape.rounded_rect(cr, width, height, 4)
end

local theme = {}

local bgColor 		        = "#191919"	-- dark gray
local accent 	            = "#e95678" -- red

theme.font		            = "Mononoki"

theme.bg_normal		        = bgColor
theme.bg_focus		        = "#59e1e3"
theme.bg_urgent		        = accent
theme.bg_minimize	        = "#444444"
theme.bg_systray	        = bgColor

theme.fg_normal		        = "#AAAAAA"
theme.fg_focus		        = "#FFFFFF"
theme.fg_urgent		        = "#FFFFFF"
theme.fg_minimize	        = "#FFFFFF"

theme.useless_gap	        = dpi(7)
theme.gap_single_client	    = true
theme.border_width	        = dpi(2)
theme.border_normal	        = "#000000"
theme.border_focus	        = accent
theme.border_marked	        = accent

theme.taglist_shape         = taglistShape
theme.taglist_spacing       = 5

theme.wallpaper		        = "~/Pictures/wallpaper/spaceman.jpeg"
theme.icon_theme	        = nil

theme.icon_size             = 16
theme.icon_color            = theme.fg_normal

theme.hotkeys_bg            = bgColor
-- theme.hotkeys_fg            = theme.accent
theme.hotkeys_fg            = theme.fg_normal
theme.hotkeys_border_width  = theme.border_width
theme.hotkeys_border_color  = theme.border_focus
theme.hotkeys_shape         = hotkeysShape

theme.icons                 = os.getenv("HOME") .. "/.config/awesome/themes/spaceman/icons/"
theme.layout_cornernw       = theme.icons .. "cornernw.png"
theme.layout_cornerne       = theme.icons .. "cornerne.png"
theme.layout_cornersw       = theme.icons .. "cornersw.png"
theme.layout_cornerse       = theme.icons .. "cornerse.png"
theme.layout_fairh          = theme.icons .. "fairh.png"
theme.layout_fairv          = theme.icons .. "fairv.png"
theme.layout_floating       = theme.icons .. "floating.png"
theme.layout_magnifier      = theme.icons .. "magnifier.png"
theme.layout_max            = theme.icons .. "max.png"
theme.layout_fullscreen     = theme.icons .. "fullscreen.png"
theme.layout_spiral         = theme.icons .. "spiral.png"
theme.layout_dwindle        = theme.icons .. "dwindle.png"
theme.layout_tile           = theme.icons .. "tile.png"
theme.layout_tiletop        = theme.icons .. "tiletop.png"
theme.layout_tilebottom     = theme.icons .. "tilebottom.png"
theme.layout_tileleft       = theme.icons .. "tileleft.png"

theme.lain_icons            = os.getenv("HOME") .. "/.config/awesome/lain/icons/layout/zenburn/"
theme.layout_termfair       = theme.icons .. "termfair.png"
theme.layout_centerfair     = theme.icons .. "centerfair.png"
theme.layout_cascade        = theme.icons .. "cascade.png"
theme.layout_cascadetile    = theme.icons .. "cascadetile.png"
theme.layout_centerwork     = theme.icons .. "centerwork.png"
theme.layout_centerworkh    = theme.icons .. "centerworkh.png"

return theme
