--[[
 ____                        _      _    _
/ ___|  ___  _   _ _ __   __| | ___| |_| |
\___ \ / _ \| | | | '_ \ / _` |/ __| __| | - Simple volume.widget for awesome wm
 ___) | (_) | |_| | | | | (_| | (__| |_| | - https://github.com/cherrynoize/ctrl
|____/ \___/ \__,_|_| |_|\__,_|\___|\__|_| - cherry-noize
]]--

-- Module imports.
local awful = require "awful"
local wibox = require "wibox"
local spawn_with_shell = awful.util.spawn_with_shell or awful.spawn.with_shell
-- Import Ctrl modules
local utils = require "ctrl.utils"
local ui = require "ctrl.ui"
local config = require "ctrl.config"

-- Initialize volume variable.
local volume = {}

-- Define widget to be used.
if config.show_progressbar then
   volume.widget = wibox.widget(ui.bar)
else
   volume.widget = wibox.widget(ui.text)
end

volume.widget.layout = wibox.layout.align.horizontal

-- Strip volume string and return a number value.
function volume.strip(lvl)
   local lvl = string.gsub(lvl,"%%","")
   lvl = string.gsub(lvl,"dB","")
   return tonumber(lvl)
end

-- Fetch current volume level.
function volume.level()
   return utils.capture("amixer sget Master | grep -oP '(?<=\\[).*?(?=\\])' | grep -F -e '%' -e 'dB' -m1")
end

-- Returns whether audio is muted. 
function volume.is_mute()
   if utils.capture("amixer sget Master | awk '/off/ { print $6 }' | grep -e '' -m1") == "[off]" then
      return true
   else
      return false
   end
end

-- Updates text.
function volume.text_update()
   local color = config.fg_color_normal

   if volume.is_mute() then
      color = config.fg_color_alert or color
   end

   volume.widget:set_markup_silently('<span color="' .. color .. '">' .. volume.level() .. '</span>')
end

-- Updates progressbar.
function volume.bar_update()
   volume.widget:set_value(volume.strip(volume.level())/100)

   if volume.is_mute() then
      volume.widget:set_color(color_mute)
      volume.widget:set_background_color(config.bg_color_alert)
   else
      volume.widget:set_color(color)
      volume.widget:set_background_color(config.bg_color_active)
   end
end

-- Updates volume widget.
function volume.update()
   if config.show_progressbar then
      volume.bar_update()
   else
      volume.text_update()
   end
end

-- Spawns program.
function volume.spawn()
   spawn_with_shell(config.soundctl_spawn)
end

function volume.up()
   os.execute("amixer sset Master " .. config.soundctl_step .. "%+")
   volume.update()
end

function volume.down()
   os.execute("amixer sset Master " .. config.soundctl_step .. "%-")
   volume.update()
end

function volume.min()
   os.execute("amixer sset Master 0%")
   volume.update()
end

function volume.half()
   os.execute("amixer sset Master 50%")
   volume.update()
end

function volume.max()
   os.execute("amixer sset Master 100%")
   volume.update()
end

function volume.overmax()
   os.execute("amixer sset Master " .. config.soundctl_uber .. "%")
   volume.update()
end

function volume.togglemute()
   if volume.is_mute() then
      os.execute("amixer sset Master unmute")
   else
      os.execute("amixer sset Master mute")
   end

   volume.update()
end

-- Mouse click events.
volume.widget:buttons(awful.util.table.join(
      awful.button({ }, 1, volume.spawn),
      awful.button({ }, 3, volume.togglemute),
      awful.button({ }, 4, volume.down),
      awful.button({ }, 5, volume.up)
   )
)

-- Initialize widget.
volume.update()

return volume
