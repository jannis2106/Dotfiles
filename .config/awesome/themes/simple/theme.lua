local gears                = require("gears")
local lain                 = require("lain")
local awful                = require("awful")
local wibox                = require("wibox")
local weather_widget       = require("awesome-wm-widgets.weather-widget.weather")

local xresources           = require("beautiful.xresources")
local dpi                  = xresources.apply_dpi

local secrets              = require("secrets")

-- [[ SHAPES ]]
local taglistShape         = function(cr, width, height)
    gears.shape.transform(gears.shape.rounded_rect):translate(0, 20)(cr, width, height, 5)
end
local hotkeysShape         = function(cr, width, height)
    gears.shape.rectangle(cr, width, height)
end
local wiboxShape           = function(cr, width, height)
    gears.shape.transform(gears.shape.rounded_rect)(cr, width, height, 5)
end

-- [[ THEME ]]
local colors               = {
    "#f07d7c",
    "#f0bb7c",
    "#85f07c",
    "#7ce9f0",
    "#e7f07c",
    "#7ca3f0",
    "#5c70d9",
    "#b67cf0",
    "#f07cd6",
    "#7cd4f0",
    "#59b8d7",
    "#3f475a"
}

local accent               = colors[1]

local bgColor              = "#262833"
local theme                = {}
theme.dir                  = "~/.config/awesome/themes/simple"
theme.font                 = "Inter semi-bold 11"
theme.bg_normal            = bgColor
theme.bg_focus             = bgColor
theme.bg_urgent            = accent
theme.bg_minimize          = "#73778c"
theme.bg_systray           = bgColor
theme.fg_normal            = "#abafc2"
theme.fg_focus             = "#f2f2f2"
theme.fg_urgent            = "#d5d6dc"
theme.fg_minimize          = "#d5d6dc"
theme.useless_gap          = dpi(8)
theme.gap_single_client    = true
theme.border_width         = dpi(3)
theme.border_normal        = bgColor
theme.border_focus         = "#d5d6dc"
theme.border_marked        = accent
theme.taglist_spacing      = 10
theme.taglist_shape        = taglistShape
theme.taglist_fg_empty     = bgColor
theme.taglist_fg_occupied  = bgColor
theme.hotkeys_bg           = bgColor
theme.hotkeys_fg           = theme.fg_normal
theme.hotkeys_border_width = theme.border_width
theme.hotkeys_border_color = theme.border_focus
theme.hotkeys_shape        = hotkeysShape
theme.menu_width           = 150
theme.menu_border_width    = 0
theme.menu_fg_focus        = accent
theme.menu_bg_focus        = bgColor
theme.menu_fg_normal       = theme.fg_focus
theme.menu_bg_normal       = bgColor
theme.menu_submenu         = "❯"
theme.icons                = os.getenv("HOME") .. "/.config/awesome/themes/icons/"
theme.layout_cornernw      = theme.icons .. "cornernw.png"
theme.layout_cornerne      = theme.icons .. "cornerne.png"
theme.layout_cornersw      = theme.icons .. "cornersw.png"
theme.layout_cornerse      = theme.icons .. "cornerse.png"
theme.layout_fairh         = theme.icons .. "fairh.png"
theme.layout_fairv         = theme.icons .. "fairv.png"
theme.layout_floating      = theme.icons .. "floating.png"
theme.layout_magnifier     = theme.icons .. "magnifier.png"
theme.layout_max           = theme.icons .. "max.png"
theme.layout_fullscreen    = theme.icons .. "fullscreen.png"
theme.layout_spiral        = theme.icons .. "spiral.png"
theme.layout_dwindle       = theme.icons .. "dwindle.png"
theme.layout_tile          = theme.icons .. "tile.png"
theme.layout_tiletop       = theme.icons .. "tiletop.png"
theme.layout_tilebottom    = theme.icons .. "tilebottom.png"
theme.layout_tileleft      = theme.icons .. "tileleft.png"
theme.lain_icons           = os.getenv("HOME") .. "/.config/awesome/lain/icons/layout/zenburn/"
theme.layout_termfair      = theme.icons .. "termfair.png"
theme.layout_centerfair    = theme.icons .. "centerfair.png"
theme.layout_cascade       = theme.icons .. "cascade.png"
theme.layout_cascadetile   = theme.icons .. "cascadetile.png"
theme.layout_centerwork    = theme.icons .. "centerwork.png"
theme.layout_centerworkh   = theme.icons .. "centerworkh.png"

theme.color                = bgColor

local margin               = 8

local markup               = lain.util.markup

-- FontAwesome Icons
local function makeFaIcon(code, color)
    return wibox.widget {
        font = "Mononoki Nerd Font ",
        markup = ' <span color="' .. color .. '">' .. code .. '</span> ',
        widget = wibox.widget.textbox
    }
end

-- widget colors
local wicolors = {
    workspace = colors[1],
    weather = colors[12],
    spotify = colors[3],
    bat = colors[9],
    volume = colors[10],
    muteVolume = colors[1],
    brightness = colors[2],
    date = colors[6],
    kb = colors[8],
}

local function setMarkup(color, text)
    return markup.fg.color(color, markup.font(theme.font, text))
end
local function setIconMarkup(color, text)
    return markup.fg.color(color, markup.font("Inter", text))
end

-- Battery
local batIcon = makeFaIcon("\u{f578}", theme.color)
local bat = lain.widget.bat {
    battery = "BAT1",
    timeout = 5,
    settings = function()
        if bat_now.status == "Charging" then
            batIcon:set_markup(setIconMarkup(theme.color, "\u{f583} "))
        elseif bat_now.status == "Full" then
            batIcon:set_markup(setIconMarkup(theme.color, "\u{f58e} "))
        else
            batIcon:set_markup(setIconMarkup(theme.color, "\u{f578} "))
        end

        widget:set_markup(setMarkup(theme.color, bat_now.perc .. "%"))
    end
}

-- Volume (Alsa)
local volumeIcon = makeFaIcon("\u{fa7d}", theme.color)
theme.volume = lain.widget.alsa {
    timeout = 1,
    settings = function()
        if volume_now.status == "off" then
            volumeIcon:set_markup(setIconMarkup(theme.color, "\u{fa80} ")) -- red on mute
        else
            volumeIcon:set_markup(setIconMarkup(theme.color, "\u{fa7d} "))
        end

        widget:set_markup(setMarkup(theme.color, volume_now.level .. "%"))
    end
}

-- Weather
local weatherr = weather_widget {
    api_key = secrets.APPID,
    coordinates = { 52.15077, 9.95112 },
    units = 'metric',
    font_name = 'Carter One 40',
    show_hourly_forecast = true,
    show_daily_forecast = true,
}

-- Week
local week = awful.widget.watch(
    "date +'%W'",
    10000,
    function(widget, stdout)
        abWeek = tonumber(stdout) % 2 == 0 and "B" or "A"
        widget:set_markup(markup.fg.color(theme.color, markup.font(theme.font .. " 9", abWeek)))
    end
)

-- Clock
local clock = awful.widget.watch(
    "date +'%T - %a, %b %d %W'",
    1,
    function(widget, stdout)
        local week = tonumber(string.match(stdout, "%s(%d+)%s*$")) % 2 == 0 and "B" or "A"
        local clockText = string.gsub(stdout, "%s(%d+)%s*$", "")

        widget:set_markup(setMarkup(theme.color, markup.font(theme.font .. " 9", week) .. " " .. clockText))
    end
)

-- Brightness
local brightIcon = makeFaIcon("\u{fbe7}", theme.color)
theme.brightness = awful.widget.watch(
    "xbacklight -get",
    0.25,
    function(widget, stdout)
        local perc = tonumber(string.format("%0.f", stdout))
        widget:set_markup(setMarkup(theme.color, perc .. "%"))
    end
)

-- Spotify
local mprisIcon = makeFaIcon("\u{f1bc}", theme.color)
local mpris = awful.widget.watch(
    { awful.util.shell, "-c", "playerctl status && playerctl metadata" },
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

        local isSpotify = source and string.find(source, "spotify")

        if artist and title and isSpotify then
            text = " " .. escape_f(artist) .. " - " .. escape_f(title)
        else
            text = "no song playing..."
        end

        widget:set_markup(setMarkup(theme.color, text:sub(1, 75)))
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

local function createWidget(widget, icon, color, fgColor, marginLeft, innerMarginLeft)
    return {
        widget = wibox.container.margin,
        left = dpi(marginLeft),
        {
            widget = wibox.container.background,
            bg = color,
            fg = (fgColor or bgColor),
            shape = wiboxShape,
            {
                widget = wibox.container.margin,
                left = dpi(innerMarginLeft or 5),
                right = dpi(5),
                top = dpi(7),
                bottom = dpi(7),
                wibox.widget { icon, widget, layout = wibox.layout.align.horizontal },
            }
        }
    }
end

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
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        layout = wibox.layout.align.horizontal(), -- makes it invisible
        buttons = awful.util.tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen = s,
        bg = theme.bg_normal,
        height = dpi(50)
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        widget = wibox.container.margin,
        top = dpi(margin),
        bottom = dpi(margin),
        left = dpi(margin),
        right = dpi(margin),
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,

                    createWidget(mpris, mprisIcon, wicolors.spotify, nil, margin, 0),
                    -- createWidget(weather.widget, weatherIcon, wicolors.weather, margin, -2),

                    createWidget(
                        weather_widget {
                            api_key = secrets.APPID,
                            coordinates = secrets.coordinates,
                            show_hourly_forecast = true,
                            show_daily_forecast = true,
                            timeout = 300,
                        }, nil, wicolors.weather, theme.fg_urgent, margin, -2),
                },
                nil,
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,

                    createWidget(bat.widget, batIcon, wicolors.bat, nil, 0),
                    createWidget(theme.volume.widget, volumeIcon, wicolors.volume, nil, margin),
                    createWidget(theme.brightness, brightIcon, wicolors.brightness, nil, margin, -2),

                    createWidget(clock, nil, wicolors.date, nil, margin),
                    createWidget(awful.widget.keyboardlayout(), nil, wicolors.kb, nil, margin),

                    {
                        widget = wibox.container.margin,
                        top = dpi(5),
                        bottom = dpi(5),
                        {
                            layout = wibox.layout.fixed.horizontal,
                            s.systray,
                        },
                    },
                }
            },

            { -- Center widgets
                layout = wibox.container.place,
                createWidget(s.mytaglist, nil, wicolors.workspace, nil, 0),
            }
        }
    }
end

return theme
