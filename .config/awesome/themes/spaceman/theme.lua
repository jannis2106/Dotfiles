local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local secrets = require("secrets")

-- [[ SHAPES ]]
local taglistShape = function(cr, width, height)
    gears.shape.transform(gears.shape.rounded_rect):translate(0, 25)(cr, width, height, 4)
end
local hotkeysShape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
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

math.randomseed(os.clock() * 100000000000)
local accent 
-- random accent color
if secrets.randomColor then 
    accent = colors[math.random(1, 6)]
else 
    accent = "#e95678"
end

local bgColor 		        = "#191919"	-- dark gray
local theme = {}
theme.dir                   = "~/.config/awesome/themes/spaceman"
theme.font		            = "Inter 11"
theme.bg_normal		        = bgColor
theme.bg_focus		        = accent
theme.bg_urgent		        = accent
theme.bg_minimize	        = "#444444"
theme.bg_systray	        = theme.bg_normal
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
    cpu = colors[1],
    mem = colors[6],
    net = colors[3],
    bat = colors[4],
    volume = colors[5],
    weather = colors[2],
}

local function setMarkup(color, text)
    return markup.fg.color(color, markup.font(theme.font, text))
end

-- Battery
local batIcon = makeFaIcon("\u{f578}", wicolors.bat)
local bat =
    lain.widget.bat {
    battery = "BAT1",
    settings = function()
        bat_notification_charged_preset = {
            title = "Battery full",
            text = "You can unplug the cable",
            timeout = 15,
            fg = "#29d398",
            bg = "#191919",
            border_color = "29d398",
            margin = 10,
            opacity = .9
        }
        bat_notification_low_preset = {
            title = "Battery low",
            text = "Plug the cable!",
            timeout = 120,
            fg = "#AAAAAA",
            bg = "#191919",
            border_color = "#fab795",
            margin = 10,
            opacity = .9
        }
        bat_notification_critical_preset = {
            title = "Battery exhausted",
            text = "Shutdown imminent",
            timeout = 30,
            fg = "#e95678",
            bg = "#191919",
            border_color = "e95678",
            margin = 10,
            opacity = .9
        }
        widget:set_markup(setMarkup(wicolors.bat, bat_now.perc .. "%"))
    end
}


-- CPU
local cpuIcon = makeFaIcon("\u{f85a}", wicolors.cpu)
local cpu =
    lain.widget.cpu {
    timeout = 1,
    settings = function()
        widget:set_markup(setMarkup(wicolors.cpu, "cpu: " .. cpu_now.usage .. "%"))
    end
}

-- MEM
local memIcon = makeFaIcon("\u{f2db}", wicolors.mem)
local mem =
    lain.widget.mem {
    timeout = 1,
    settings = function()
        widget:set_markup(setMarkup(wicolors.mem, "mem: " .. mem_now.perc .. "% (" .. mem_now.used .. "MiB)"))
    end
}

-- Net
local netIcon = makeFaIcon("\u{f1eb}", wicolors.net)
local net =
    lain.widget.net {
    settings = function()
        widget:set_markup(setMarkup(wicolors.net, " " .. net_now.received .. " ↓↑ " .. net_now.sent))
    end
}

-- Volume (Alsa)
local volumeIcon = makeFaIcon("\u{fa7d}", wicolors.volume)
theme.volume =
    lain.widget.alsa {
    timeout = 1,
    settings = function()
        vlevel = volume_now.level .. "%"

        if volume_now.status == "off" then
            vlevel = vlevel .. " M"
        end

        widget:set_markup(setMarkup(wicolors.volume, vlevel))
    end
}

-- Weather
local weatherIcon = makeFaIcon("\u{e30d}", wicolors.weather)
local weather =
    lain.widget.weather {
    APPID = secrets.APPID,
    city_id = secrets.city_id,
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(setMarkup(wicolors.weather, " " .. descr .. " @ " .. units .. "°C"))
    end,
    showpopup = "off"
}

-- Clock
local clockIcon = makeFaIcon("\u{f133}", "#ffffff")
local clock =
    awful.widget.watch(
    "date +'%R - %a, %B %d, %Y'",
    1,
    function(widget, stdout)
        widget:set_markup(setMarkup("#ffffff", stdout))
    end
)

-- Seperator "|"
local separator =
    wibox.widget {
    markup = "  |",
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

    -- local tagList = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local tagList = {" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "}

    -- Each screen has its own tag table.
    awful.tag(tagList, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

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
        buttons = awful.util.taglist_buttons
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
            bg = theme.bg_normal .. "aa"
        }
    )

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 0,
            --wibox.widget {cpuIcon, cpu.widget, layout = wibox.layout.align.horizontal},
            --separator,
            --wibox.widget {memIcon, mem.widget, layout = wibox.layout.align.horizontal},
            --separator,
            wibox.widget {netIcon, net.widget, layout = wibox.layout.align.horizontal},
            separator,
            wibox.widget {batIcon, bat.widget, layout = wibox.layout.align.horizontal},
            separator,
            wibox.widget {volumeIcon, theme.volume.widget, layout = wibox.layout.align.horizontal},
            separator,
            wibox.widget {weatherIcon, weather.widget, layout = wibox.layout.align.horizontal},
            separator,
            wibox.widget {clockIcon, clock, layout = wibox.layout.align.horizontal},
            -- wibox.widget.systray(),
             -- wibox.widget {markup = "  ", align = "center", valign = "center", widget = wibox.widget.textbox},
            separator,
            awful.widget.keyboardlayout(),
            s.mylayoutbox
        }
    }
end

return theme
