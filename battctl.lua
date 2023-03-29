--[[
 ____        _   _       _    _
| __ )  __ _| |_| |_ ___| |_ | |
|  _ \ / _` | __| __/ __| __|| | - Simple battery widget for awesome wm
| |_) | (_| | |_| || (__| |_ | | - https://github.com/cherrynoize/ctrl
|____/ \__,_|\__|\__\___|\__||_| - cherry-noize
]]--

-- Module imports.
local awful = require "awful"
local naughty = require "naughty"
local wibox = require "wibox"
local gears = require "gears"
local math = require "math"
-- Import Ctrl modules
local utils = require "ctrl.utils"
local ui = require "ctrl.ui"
local config = require "ctrl.config"

-- Initialize battery variable.
local battery = {}
battery.alert_level = 0 -- Battery state. 

-- Define widget to be used.
if config.show_progressbar then
   battery.widget = wibox.widget(ui.bar)
else
   battery.widget = wibox.widget(ui.text)
end

battery.widget.layout = wibox.layout.align.horizontal

-- Reads battery charge.
-- Values for when are "now", "full" or "full_design".
function battery.charge(when)
   return utils.read(config.path .. "charge_" .. when)
end

-- Returns battery level as percentage.
function battery.level()
   return math.floor(utils.percent(battery.charge("now"), battery.charge("full")))
end

-- Returns whether the battery is in a certain state.
-- Possible values for state are "charging", "low" or "crit".
function battery.is(state)
   if state == "full" then
      return battery.level() >= config.battery_full
   elseif state == "charging" then
      local status = utils.read(config.path .. "status"):gsub("%s+", "")
      return status == "Charging" or status == "Full"
   elseif state == "crit" then
      return battery.level() <= config.crit_level
   elseif state == "low" then
      return battery.level() <= config.low_level
   end
end

-- Update text.
function battery.text_update()
   local color = config.fg_color_alert

   if battery.is("charging") then
      battery.alert_level = 0
      color = config.fg_color_active
   elseif battery.is("crit") and battery.alert_level ~= 2 then
      battery.alert_level = 2
      color = config.fg_color_crit
      naughty.notify({title = "Critical battery. Plug in your device now."})
   elseif battery.is("low") and battery.alert_level ~= 1 then
      battery.alert_level = 1
      color = config.fg_color_low
      naughty.notify({title = "Low battery. You may want to plug in your device."})
   end

   if battery.is("full") then
      battery.text_format = config.full_prefix .. '100%' .. config.full_suffix
   elseif battery.is("charging") then
      battery.text_format = config.charging_prefix .. battery.level() .. config.charging_suffix
   else
      battery.text_format = config.discharging_prefix .. battery.level() .. config.discharging_suffix
   end

   battery.widget:set_markup_silently('<span color="' .. color .. '">' .. battery.text_format .. '</span>')
end

-- Update progressbar.
function battery.bar_update()
   battery.widget:set_value(battery.level() / 100)

   if battery.is("charging") then
      battery.widget:set_color(config.fg_color_active)
      battery.widget:set_background_color(config.bg_color_active)
   elseif battery.is("crit") then
      battery.widget:set_color(config.fg_color_crit)
      battery.widget:set_background_color(config.bg_color_crit)
   elseif battery.is("low") then
      battery.widget:set_color(config.fg_color_low)
      battery.widget:set_background_color(config.bg_color_low)
   else
      battery.widget:set_color(config.fg_color_alert)
      battery.widget:set_background_color(config.bg_color_alert)
   end

   if battery.is("charging") then
      battery.text_format = '**' .. battery.level() .. '**'
   else
      battery.text_format = battery.level() .. '%'
   end
end

-- Update widget value.
function battery.update()
   if config.show_progressbar then
      battery.bar_update()
   else
      battery.text_update()
   end
end

-- Popup notification.
function battery.popup(when)
   naughty.notify({title = utils.read(config.path .. "charge_" .. when)})
   battery.update()
end

-- Mouse click events.
battery.widget:buttons(awful.util.table.join(
      awful.button({ }, 1, function() battery.popup("now") end),
      awful.button({ }, 3, function() battery.popup("full") end)
   )
)

-- Set timer and initialize widget.
battery.timer = gears.timer {
   timeout   = config.timeout,
   call_now  = true,
   autostart = true,
   callback  = battery.update
}

return battery
