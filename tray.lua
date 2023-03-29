-- Minimal tray icon container for awesome wm
-- https://github.com/cherrynoize/ctrl

local wibox = require("wibox")

-- Systray icon container
local tray    = {}
tray.widget   = wibox.widget.systray()
tray.shelf    = require("ctrl.container")(tray.widget)

return tray
