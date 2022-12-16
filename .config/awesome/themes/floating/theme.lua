local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local secrets = require("secrets")

-- [[ SHAPES ]]
local taglistShape = function(cr, width, height)
    gears.shape.transform(gears.shape.rounded_rect):translate(0, 17.5)(cr, width, height, 5)
end
local hotkeysShape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end
local wiboxShape = function(cr, width, height)
    gears.shape.transform(gears.shape.rounded_rect)(cr, width, height, 10)
end

-- [[ THEME ]]
local colors = {
    "#e95678",
    "#29d398",
    "#fab794",
    "#26bbd9",
    "#ee64ac",
    "#59e1e3"
}

local accent = colors[2]

local bgColor 		        = "#000000"	-- black
local theme = {}
theme.dir                   = "~/.config/awesome/themes/spaceman"
theme.font		            = "Inter 11"
theme.bg_normal		        = bgColor
theme.bg_focus		        = accent
theme.bg_urgent		        = accent
theme.bg_minimize	        = "#444444"
theme.bg_systray	        = theme.bg_normal
theme.fg_normal		        = "#AAAAAA"
theme.fg_focus		        = accent
theme.fg_urgent		        = "#FFFFFF"
theme.fg_minimize	        = "#FFFFFF"
theme.useless_gap	        = dpi(7)
theme.gap_single_client	    = true
theme.border_width	        = dpi(2)
theme.border_normal	        = "#000000"
theme.border_focus	        = accent
theme.border_marked	        = accent
theme.taglist_shape         = taglistShape
theme.taglist_spacing       = 30
-- theme.wallpaper		        = "~/Pictures/wallpaper/ghost_in_the_shell.jpg"
theme.icon_theme	        = nil
theme.icon_color            = theme.fg_normal
theme.hotkeys_bg            = bgColor
-- theme.hotkeys_fg            = theme.accent
theme.hotkeys_fg            = theme.fg_normal
theme.hotkeys_border_width  = theme.border_width
theme.hotkeys_border_color  = theme.border_focus
theme.hotkeys_shape         = hotkeysShape
theme.menu_width            = 150
theme.menu_border_width     = 0
theme.menu_fg_focus         = accent
theme.menu_bg_focus         = bgColor
theme.menu_fg_normal        = theme.fg_focus
theme.menu_bg_normal	    = bgColor
theme.menu_submenu          = "❯"
theme.icons                 = os.getenv("HOME") .. "/.config/awesome/themes/icons/"
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

theme.transparency          = "99"
theme.color                 = "#cccccc"

local markup = lain.util.markup

-- FontAwesome Icons
local function makeFaIcon( code, color )
    return wibox.widget{
        font = "Mononoki Nerd Font ",
        markup = ' <span color="'.. color ..'">' .. code .. '</span> ',
        widget = wibox.widget.textbox
    }
end

-- widget colors
local wicolors = {
    spotify = colors[2],
    weather = colors[3],
    bat = colors[4],
    volume = colors[2],
    muteVolume = colors[1],
    brightness = "#ffffff",
}

local function setMarkup(color, text)
    return markup.fg.color(color, markup.font(theme.font, text))
end
local function setIconMarkup(color, text)
    return markup.fg.color(color, markup.font("Mononoki Nerd Font", text))
end

-- Battery
local batIcon = makeFaIcon("\u{f578}", wicolors.bat)
local bat =
    lain.widget.bat {
    battery = "BAT1",
    timeout = 5,
    settings = function()
        if bat_now.status == "Charging" then
            batIcon:set_markup(setIconMarkup(wicolors.bat, "\u{f583} "))
        elseif bat_now.status == "Full" then
            batIcon:set_markup(setIconMarkup(wicolors.bat, "\u{f58e} "))
        else
            batIcon:set_markup(setIconMarkup(wicolors.bat, "\u{f578} "))
        end

        widget:set_markup(setMarkup(theme.color, bat_now.perc .. "%"))
    end
}

-- Volume (Alsa)
local volumeIcon = makeFaIcon("\u{fa7d}", wicolors.volume)
theme.volume =
    lain.widget.alsa {
    timeout = 1,
    settings = function()
        if volume_now.status == "off" then
            volumeIcon:set_markup(setIconMarkup(wicolors.muteVolume, "\u{fa80} ")) -- red on mute
        else
            volumeIcon:set_markup(setIconMarkup(wicolors.volume, "\u{fa7d} "))
        end

        widget:set_markup(setMarkup(theme.color, volume_now.level .. "%"))
    end
}

-- Weather
local weatherIcon = makeFaIcon("\u{e30d}", wicolors.weather)
local weather =
    lain.widget.weather {
    APPID = secrets.APPID,
    city_id = secrets.city_id,
    settings = function()
        descr = weather_now["weather"][1]["description"]
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(setMarkup(theme.color, " " .. descr .. " / " .. units .. "°C"))
    end,
    showpopup = "off"
}

-- Clock
local clock =
    awful.widget.watch(
    "date +'%R - %a, %b %d'",
    1,
    function(widget, stdout)
        widget:set_markup(setMarkup(theme.color, stdout))
    end
)

-- Brightness
local brightIcon = makeFaIcon("\u{fbe7}", wicolors.brightness)
local bright = 
    awful.widget.watch(
    "xbacklight -get", 
    0.05, 
    function(widget, stdout)
        local perc = tonumber(string.format("%0.f", stdout))
        widget:set_markup(setMarkup(theme.color, perc .. "%"))
    end
)

-- Spotify
local mprisIcon = makeFaIcon("\u{f1bc}", wicolors.spotify)
local mpris, mpris_timer = awful.widget.watch(
    {awful.util.shell, "-c", "playerctl status && playerctl metadata" }, 
    2, 
    function(widget, stdout)
        local escape_f = require("awful.util").escape

        local text = ""

        local artist = nil
        local title = nil
        local album = nil
        local source = nil

        for line in string.gmatch(stdout, "[^\r\n]+") do
            if not artist then
                artist = string.match(line, ".*artist%s*(.+)")
            end

            if not title then
                title = string.match(line, ".*title%s*(.+)")
            end

            if not album then
                album = string.match(line, ".*artUrl%s*(.+)")
            end

            if not source then
                source = string.match(line, ".*trackid%s*(.+)")
            end
        end

        local isSpotify = string.find(source, "spotify")

        if artist and title and isSpotify then
            text = " " .. escape_f(artist) .. "   " .. escape_f(title)
        else
            text = "no song playing..."    
        end
    
        widget:set_markup(setMarkup(theme.color, text:sub(1, 75)))
    end
)

local week = awful.widget.watch(
    "date +'%W'", 
    10000, 
    function(widget, stdout)
        abWeek = tonumber(stdout) % 2 == 0 and "A" or "B"
        widget:set_markup(markup.fg.color(theme.color, markup.font(theme.font .. " 9", abWeek)))
    end
)

-- Seperator "|"
local separator =
    wibox.widget {
    markup = "      ",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local smallSeparator =
    wibox.widget {
    markup = "  ",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

function theme.at_screen_connect(s)
    -- Wallpaper
    -- set_wallpaper(s)
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    local tagList = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    --local tagList = {"  1  ", "  2  ", "  3  ", "  4  ", "  5  ", "  6  ", "  7  ", "  8  ", "  9  "}

    -- Each screen has its own tag table.
    awful.tag(tagList, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a systray
    s.systray = wibox.widget.systray()
    s.systray.visible = false

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.layout.inc( 1) end),
        awful.button({ }, 3, function() awful.layout.inc(-1) end),
        awful.button({ }, 4, function() awful.layout.inc( 1) end),
        awful.button({ }, 5, function() awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist =
        awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
    }

    -- Create a tasklist widget
    s.mytasklist =
        awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        layout = wibox.layout.align.horizontal(), -- makes it invisible
        buttons = awful.util.tasklist_buttons
    }

    -- Create the wibox
    s.mywibox =
        awful.wibar(
        {
            position = "top",
            screen = s,
            bg = theme.bg_normal .. "00",
            height = dpi(50)
        }
    )

    -- Add widgets to the wibox
    s.mywibox:setup {
        top = dpi(5),
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin,
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.container.background,
                        bg = theme.bg_normal .. theme.transparency,
                        shape = wiboxShape,
                        {
                            widget = wibox.container.margin,
                            left = dpi(10),
                            right = dpi(10),
                            top = dpi(10),
                            bottom = dpi(10),
                            type = "desktop",
                            wibox.widget {mprisIcon, mpris, layout = wibox.layout.align.horizontal},
                        }
                    },
                    {
                        widget = wibox.container.margin,
                        left = dpi(10),
                        {
                            widget = wibox.container.background,
                            bg = theme.bg_normal .. theme.transparency,
                            shape = wiboxShape,
                            {
                                widget = wibox.container.margin,
                                left = dpi(10),
                                right = dpi(10),
                                top = dpi(10),
                                bottom = dpi(10),
                                wibox.widget {weatherIcon, weather.widget, layout = wibox.layout.align.horizontal},
                            }
                        }
                    }
                },
                nil,
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.container.margin,
                        left = dpi(100),
                        {
                            widget = wibox.container.background,
                            bg = theme.bg_normal .. theme.transparency,
                            shape = wiboxShape,
                            {
                                widget = wibox.container.margin,
                                left = dpi(10),
                                right = dpi(15),
                                top = dpi(10),
                                bottom = dpi(10),
                                {
                                    
                                    layout = wibox.layout.fixed.horizontal,
                                    wibox.widget {batIcon, bat.widget, layout = wibox.layout.align.horizontal},
                                    separator,
                                    volumeIcon,
                                    theme.volume.widget,
                                    separator,
                                    brightIcon,
                                    bright
                                },
                                
                            }
                        }
                    },
                    {
                        widget = wibox.container.margin,
                        left = dpi(10),
                        {
                            widget = wibox.container.background,
                            bg = theme.bg_normal .. theme.transparency,
                            shape = wiboxShape,
                            {
                                widget = wibox.container.margin,
                                left = dpi(10),
                                right = dpi(10),
                                top = dpi(10),
                                bottom = dpi(10),
                                {
                                    layout = wibox.layout.fixed.horizontal,
                                    week,
                                    smallSeparator,
                                    clock,
                                    separator,
                                    awful.widget.keyboardlayout(),
                                    s.systray,
                                },
                            }
                        }
                    }
                }
            },
            { -- Center widgets
                layout = wibox.container.place,
                valign = "center",
                halign = "center",
                {
                    widget = wibox.container.background,
                    bg = theme.bg_normal .. theme.transparency,
                    shape = wiboxShape,
                    {
                        widget = wibox.container.margin,
                        left = dpi(15),
                        right = dpi(15),
                        top = dpi(12),
                        bottom = dpi(12),
                        s.mytaglist,
                    }
                }
            },
        }
    }

end

return theme
