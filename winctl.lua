--[[
__        ___            _   _
\ \      / (_)_ __   ___| |_| |
 \ \ /\ / /| | '_ \ / __| __| | - Simple window controls for awesome wm
  \ V  V / | | | | | (__| |_| | - https://github.com/cherrynoize/ctrl
   \_/\_/  |_|_| |_|\___|\__|_| - cherry-noize
]]--

-- Module imports
local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
-- Import Ctrl modules
local ui = require "ctrl.ui"
local config = require "ctrl.config"

local winctl = {}

winctl.widget = wibox.widget(ui.text)
winctl.widget.layout = wibox.layout.align.horizontal

function winctl.update()
   winctl.widget:set_markup_silently('<span color="' .. config.fg_color_normal .. '">' .. '+' .. '</span>')
end

-- Mouse click events
winctl.widget:buttons(awful.util.table.join(
      awful.button({ }, 1, function() end), -- Left click
      awful.button({ }, 3, function() end) -- Right click
   )
)

-- Set timer and initialize widget
winctl.timer = gears.timer {
   timeout   = config.timeout,
   call_now  = true,
   autostart = true,
   callback  = winctl.update
}

return winctl
