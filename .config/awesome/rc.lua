-- Standard awesome library
local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")

-- Widget and layout library
local wibox         = require("wibox")

-- Theme handling library
local beautiful     = require("beautiful")

-- Notification library
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
                      require("awful.hotkeys_popup.keys")

-- lain
local lain          = require("lain")

-- secrets
local secrets       = require("secrets")

if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true
            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

beautiful.init("~/.config/awesome/themes/spaceman/theme.lua")

modkey      = "Mod4"
terminal    = "alacritty"
editor      = os.getenv("EDITOR") or "nvim"
editor_cmd  = terminal .. " -e " .. editor
browser     = os.getenv("HOME") .. "/Applications/Brave_8529d5a0c6a04459bd09244c07f440fd.AppImage"

-- awesome variables
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    lain.layout.termfair
    -- lain.layout.termfair.center,
    -- lain.layout.cascade,
    -- lain.layout.cascade.tile,
}

-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

myapplicationmenu = {
    { "Development", {
        { "Neovim", terminal .. " -e nvim" },
        { "VSCode", "code" }
    }},
    { "Graphics", {
        { "Inkscape", "inkscape" }
    }},
    { "Internet", {
        { "Brave", browser }
    }},
    { "Office", {
        { "OnlyOffice", os.getenv("HOME") .. "/Applications/DesktopEditors-x86_64.AppImage" },
        { "Obsidian", "obsidian" }
    }},
    { "Multimedia", {
        { "Spotify", "spotify" }
    }},
    { "System", {
        { "PCManFM", "pcmanfm" },
        { "Vifm", terminal .. " -e vifm" },
        { "Htop", terminal .. " -e htop"},
        { "KeePass", "keepassxc"}
    }}
}

mymainmenu = awful.menu({ 
    items = { 
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
        { "all applications", myapplicationmenu }
    },
    right_margin = 125
})

mylauncher = awful.widget.launcher({ 
    image = beautiful.awesome_icon,
    menu = mymainmenu 
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- FontAwesome Icons
local function makeFaIcon( code, color )
  return wibox.widget{
    font = "Mononoki Nerd Font ",
    markup = ' <span color="'.. color ..'">' .. code .. '</span> ',
    -- align  = 'center',
    -- valign = 'center',
    widget = wibox.widget.textbox
  }
end

-- Lain Widgets
local markup = lain.util.markup

local colors = {
    "#e95678", -- red
    "#29d389", -- green
    "#fab795", -- yellow
    "#26bbd9", -- blue
    "#ee64ac", -- pink
    "#59e1e3", -- cyan
}

-- randomize colors
math.randomseed(os.clock() * 100000000000)
function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

if secrets.randomWidgetColor then
    shuffle(colors)
end

local wicolors = {
    cpu = colors[1],
    mem = colors[2],
    net = colors[3],
    bat = colors[4],
    volume = colors[5],
    weather = colors[6]
}

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
        widget:set_markup(markup.fg.color(wicolors.bat, bat_now.perc .. "%"))
    end
}

local cpuIcon = makeFaIcon("\u{f85a}", wicolors.cpu)
local cpu =
    lain.widget.cpu {
    timeout = 1,
    settings = function()
        widget:set_markup(markup.fg.color(wicolors.cpu, "cpu: " .. cpu_now.usage .. "%"))
    end
}

local memIcon = makeFaIcon("\u{f2db}", wicolors.mem)
local mem =
    lain.widget.mem {
    timeout = 1,
    settings = function()
        widget:set_markup(markup.fg.color(wicolors.mem, "mem: " .. mem_now.perc .. "% (" .. mem_now.used .. "MiB)"))
    end
}

local netIcon = makeFaIcon("\u{f1eb}", wicolors.net)
local net =
    lain.widget.net {
    settings = function()
        widget:set_markup(markup.fg.color(wicolors.net, " " .. net_now.received .. " ↓↑ " .. net_now.sent))
    end
}

local volumeIcon = makeFaIcon("\u{fa7d}", wicolors.volume)
local volume =
    lain.widget.alsa {
    timeout = 1,
    settings = function()
        vlevel = volume_now.level .. "%"

        if volume_now.status == "off" then
            vlevel = vlevel .. " M"
        end

        widget:set_markup(markup.fg.color(wicolors.volume, vlevel))
    end
}

local cal =
    lain.widget.cal {
    attach_to = {
        mytextclock
    },
    week_number = "left",
    notification_preset = {
        font = "Mononoki",
        fg = "#dddddd",
        bg = "#191919"
    }
}
mytextclock:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            cal.show(7)
        end
    end
)

local weatherIcon = makeFaIcon("\u{e30d}", wicolors.weather)
local weather =
    lain.widget.weather {
    APPID = secrets.APPID,
    city_id = secrets.city_id,
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fg.color(wicolors.weather, " " .. descr .. " @ " .. units .. "°C"))
    end,
    showpopup = "off"
}

local clockIcon = makeFaIcon("\u{f133}", "#ffffff")
local clock =
    awful.widget.watch(
    "date +'%R - %a, %B %d, %Y'",
    1,
    function(widget, stdout)
        widget:set_markup(markup.fg.color("#ffffff", stdout))
    end
)

local separator =
    wibox.widget {
    markup = "  |",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}
awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)

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
            buttons = taglist_buttons
        }

        -- Create a tasklist widget
        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            layout = wibox.layout.align.horizontal(), -- makes it invisible
            buttons = tasklist_buttons
        }

        -- Create the wibox
        s.mywibox =
            awful.wibar(
            {
                position = "top",
                screen = s,
                bg = beautiful.bg_normal .. "aa"
            }
        )

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox
            },
            s.mytasklist, -- Middle widget
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = 0,
                -- mykeyboardlayout,
                wibox.widget {cpuIcon, cpu.widget, layout = wibox.layout.align.horizontal},
                separator,
                wibox.widget {memIcon, mem.widget, layout = wibox.layout.align.horizontal},
                separator,
                wibox.widget {netIcon, net.widget, layout = wibox.layout.align.horizontal},
                separator,
                wibox.widget {batIcon, bat.widget, layout = wibox.layout.align.horizontal},
                separator,
                wibox.widget {volumeIcon, volume.widget, layout = wibox.layout.align.horizontal},
                separator,
                wibox.widget {weatherIcon, weather.widget, layout = wibox.layout.align.horizontal},
                separator,
                wibox.widget {clockIcon, clock, layout = wibox.layout.align.horizontal},
                -- mytextclock,
                -- wibox.widget.systray(),
                wibox.widget {markup = "  ", align = "center", valign = "center", widget = wibox.widget.textbox},
                s.mylayoutbox
            }
        }
    end
)

-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys =
    gears.table.join(
    awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
    awful.key({modkey}, "Left", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    awful.key({modkey}, "j", function()
            awful.client.focus.byidx(1)
        end, {description = "focus next by index", group = "client"}
    ),
    awful.key({modkey}, "k", function()
            awful.client.focus.byidx(-1)
        end, {description = "focus previous by index", group = "client"}
    ),
    awful.key({modkey}, "w", function()
            mymainmenu:show()
        end, {description = "show main menu", group = "awesome"}
    ),

    -- Layout manipulation
    awful.key({modkey, "Shift"}, "j", function()
            awful.client.swap.byidx(1)
        end, {description = "swap with next client by index", group = "client"}
    ),
    awful.key({modkey, "Shift"}, "k", function()
            awful.client.swap.byidx(-1)
        end, {description = "swap with previous client by index", group = "client"}
    ),
    awful.key({modkey, "Control"}, "j", function()
            awful.screen.focus_relative(1)
        end, {description = "focus the next screen", group = "screen"}
    ),
    awful.key({modkey, "Control"}, "k", function()
            awful.screen.focus_relative(-1)
        end, {description = "focus the previous screen", group = "screen"}
    ),
    awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key({modkey}, "Tab", function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, {description = "go back", group = "client"}
    ),

    -- Standard program
    awful.key({modkey}, "Return", function()
            awful.spawn(terminal)
        end, {description = "open a terminal", group = "launcher"}
    ),
    awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({modkey, "Shift"}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),
    awful.key({modkey}, "l", function()
            awful.tag.incmwfact(0.05)
        end, {description = "increase master width factor", group = "layout"}
    ),
    awful.key({modkey}, "h", function()
            awful.tag.incmwfact(-0.05)
        end, {description = "decrease master width factor", group = "layout"}
    ),
    awful.key({modkey, "Shift"}, "h", function()
            awful.tag.incnmaster(1, nil, true)
        end, {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key({modkey, "Shift"}, "l", function()
            awful.tag.incnmaster(-1, nil, true)
        end, {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key({modkey, "Control"}, "h", function()
            awful.tag.incncol(1, nil, true)
        end, {description = "increase the number of columns", group = "layout"}
    ),
    awful.key({modkey, "Control"}, "l", function()
            awful.tag.incncol(-1, nil, true)
        end, {description = "decrease the number of columns", group = "layout"}
    ),
    awful.key({modkey}, "space", function()
            awful.layout.inc(1)
        end, {description = "select next", group = "layout"}
    ),
    awful.key({modkey, "Shift"}, "space", function()
            awful.layout.inc(-1)
        end, {description = "select previous", group = "layout"}
    ),
    awful.key({modkey, "Control"}, "n", function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end, {description = "restore minimized", group = "client"}
    ),

    -- Prompt
    awful.key({modkey}, "r",
        function()
            awful.util.spawn("rofi -show drun")
        end, {description = "run rofi prompt", group = "launcher"}
    ),
    awful.key({modkey}, "x", function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end, {description = "lua execute prompt", group = "awesome"}
    ),

    -- Menubar
    awful.key({modkey}, "p", function()
            menubar.show()
        end, {description = "show the menubar", group = "launcher"}
    ),
    
    -- Volume
    awful.key({}, "XF86AudioRaiseVolume", function()
            os.execute(string.format("amixer set %s 1%%+", volume.channel))
            volume.update()
        end, {description = "increase volume", group = "widgets"}
    ),
    awful.key({}, "XF86AudioLowerVolume", function()
            os.execute(string.format("amixer set %s 1%%-", volume.channel))
            volume.update()
        end, {description = "decrease volume", group = "widgets"}
    ),
    awful.key({}, "XF86AudioMute", function()
            os.execute(string.format("amixer set %s toggle", volume.togglechannel or volume.channel))
            volume.update()
        end, {description = "toggle volume", group = "widgets"}
    ),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function()
            awful.util.spawn("xbacklight -inc 10")
        end, {description = "increase backlight by 5", group = "screen"}
    ),
    awful.key({}, "XF86MonBrightnessDown", function()
            awful.util.spawn("xbacklight -dec 10")
        end, {description = "decrease backlight by 5", group = "screen"}
    ),

    -- Screenshot
    awful.key({}, "Print", function()
            awful.util.spawn("flameshot full -p /home/jannis/Pictures/screenshots")
        end, {description = "take screenshot", group = "screen"}
    ),

    -- Browser
    awful.key({modkey}, "b", function()
            awful.spawn(browser)
        end, {description = "Launch Brave", group = "launcher"}
    ),

    -- File Explorer
    awful.key({modkey}, "e", function()
            awful.spawn("pcmanfm")
        end, {description = "Launch PCManFM", group = "launcher"}
    ),
    
    -- VSCode
    awful.key({modkey}, "c", function()
            awful.spawn("code")
        end, {description = "Launch VSCode", group = "launcher"}
    )
)

clientkeys =
    gears.table.join(
    awful.key({modkey}, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, {description = "toggle fullscreen", group = "client"}
    ),
    awful.key({modkey, "Shift"}, "c", function(c)
            c:kill()
        end, {description = "close", group = "client"}
    ),
    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key({modkey, "Control"}, "Return", function(c)
            c:swap(awful.client.getmaster())
        end, {description = "move to master", group = "client"}
    ),
    awful.key({modkey}, "o", function(c)
            c:move_to_screen()
        end, {description = "move to screen", group = "client"}
    ),
    awful.key({modkey}, "t", function(c)
            c.ontop = not c.ontop
        end, {description = "toggle keep on top", group = "client"}
    ),
    awful.key({modkey}, "n", function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, {description = "minimize", group = "client"}
    ),
    awful.key({modkey}, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, {description = "(un)maximize", group = "client"}
    ),
    awful.key({modkey, "Control"}, "m", function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end, {description = "(un)maximize vertically", group = "client"}
    ),
    awful.key({modkey, "Shift"}, "m", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end, {description = "(un)maximize horizontally", group = "client"}
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys =
        gears.table.join(
        globalkeys,

        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),

        -- Toggle tag display.
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),

        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        
        -- Toggle tag on focused client.
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    },
    
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {type = {"normal", "dialog"}},
        properties = {titlebars_enabled = false}
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 5)
        end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c):setup {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- Autostart Applications
awful.spawn.with_shell("picom")
awful.spawn.with_shell("pulseaudio")    
