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

local themes = {
    "spaceman", -- 1
    "floating", -- 2
    "floating-bw", --3
    "simple", --4
}
-- choose theme
local theme_chosen = themes[4]
local theme_path = "~/.config/awesome/themes/" .. theme_chosen .. "/theme.lua"
beautiful.init(theme_path)

modkey      = "Mod4"
terminal    = "alacritty"
editor      = os.getenv("EDITOR") or "nvim"
editor_cmd  = terminal .. " -e " .. editor
-- browser     = os.getenv("HOME") .. "/Applications/Brave_8529d5a0c6a04459bd09244c07f440fd.AppImage"
    browser     = "brave"
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

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

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

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

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
    -- awful.key({modkey}, "p", function()
    --         menubar.show()
    --     end, {description = "show the menubar", group = "launcher"}
    -- ),
    
    -- Volume
    awful.key({}, "XF86AudioRaiseVolume", function()
            os.execute(string.format("amixer set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end, {description = "increase volume", group = "widgets"}
    ),
    awful.key({}, "XF86AudioLowerVolume", function()
            os.execute(string.format("amixer set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end, {description = "decrease volume", group = "widgets"}
    ),    
    awful.key({"Shift"}, "XF86AudioRaiseVolume", function()
            os.execute(string.format("amixer set %s 10%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end, {description = "increase volume by 10", group = "widgets"}
    ),
    awful.key({"Shift"}, "XF86AudioLowerVolume", function()
            os.execute(string.format("amixer set %s 10%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end, {description = "decrease volume by 10", group = "widgets"}
    ),
    awful.key({}, "XF86AudioMute", function()
            os.execute(string.format("amixer set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end, {description = "toggle volume", group = "widgets"}
    ),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function()
            awful.util.spawn("xbacklight -inc 1")
        end, {description = "increase backlight by 1", group = "screen"}
    ),
    awful.key({}, "XF86MonBrightnessDown", function()
            awful.util.spawn("xbacklight -dec 1")
        end, {description = "decrease backlight by 1", group = "screen"}
    ),
    awful.key({"Shift"}, "XF86MonBrightnessUp", function()
            awful.util.spawn("xbacklight -inc 10")
        end, {description = "increase backlight by 10", group = "screen"}
    ),
    awful.key({"Shift"}, "XF86MonBrightnessDown", function()
            awful.util.spawn("xbacklight -dec 10")
        end, {description = "decrease backlight by 10", group = "screen"}
    ),
    -- Screenshot
    awful.key({modkey}, "Print", function()
            awful.util.spawn("flameshot full -p /home/jannis/Pictures/screenshots")
        end, {description = "take screenshot", group = "screen"}
    ),

    -- Toggle Keyboard Layout
    awful.key({"Shift"}, "space", function()
            awful.util.spawn("sh /home/jannis/.local/bin/toggle_kbd.sh")
        end, {description = "Toggle Keyboard Layout", group = "screen"}
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
    ),

    -- Obsidian
    awful.key({modkey, "Shift"}, "o", function()
        awful.spawn("obsidian")
        end, {description = "Launch Obsidian", group = "launcher"}
    ),

    -- toggle systray
    awful.key({modkey}, "=", function()
            awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
        end, {description = "Toggle systray visibility", group = "custom"}
    ),

    -- deadd notification center
    awful.key({modkey}, "p", function()
        awful.spawn.with_shell("kill -s USR1 $(pidof deadd-notification-center)")
        end, {description = "Toggle Notification Center", group = "custom"}
    ),

    -- lock
    awful.key({modkey}, "XF86PowerOff", function()
        awful.spawn.with_shell("i3lock -c 000000")
    end, {description = "lock with i3lock", group = "awesome"}
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
awful.spawn.with_shell("picom --experimental-backend")
awful.spawn.with_shell("pulseaudio")
awful.spawn.with_shell("deadd-notification-center")
awful.spawn.with_shell("feh --randomize --bg-fill ~/Pictures/wallpaper/simple/*")
awful.spawn.with_shell("dropbox")
awful.spawn.with_shell("python /home/jannis/workspace/HLTVTerminal/App.py")
awful.util.spawn("xinput set-prop 'SYNA7DAB:01 06CB:CD40 Touchpad' 'Synaptics Tap Action' 1 1 1 2 1 3")
