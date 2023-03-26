--[[
 _     _       _     _       _   _
| |   (_) __ _| |__ | |_ ___| |_| |
| |   | |/ _` | '_ \| __/ __| __| | - Simple backlight widget for awesome wm
| |___| | (_| | | | | || (__| |_| | - https://github.com/cherrynoize/ctrl
|_____|_|\__, |_| |_|\__\___|\__|_| - cherry-noize
         |___/
]]--

-- Module imports.
local awful = require("awful")
local wibox = require("wibox")

-- Path to the widget or plugin directory where this
-- module is.
ctrl = "widgets.ctrl."

-- Import widget files.
local utils = require (ctrl .. ".utils")
local ui = require (ctrl .. ".ui")
local config = require (ctrl .. ".config")

-- Initialize brightness variable.
local brightness = {}

-- Return path to brightness file. 
function path_to_file(dir, file) 
   return config.backlight_path .. '/' .. dir .. '/' .. file
end

-- Path to brightness.
brightness.file = utils.anyfile(
   path_to_file(config.intel_dir, config.brightness_file), -- Intel.
   path_to_file(config.amd_dir, config.brightness_file), -- AMD.
   path_to_file(utils.scandir(config.backlight_path)[3], config.brightness_file) -- Fallback (brute-read anything from backlight dir).
)

-- Path to max_brightness.
brightness.max_file = utils.anyfile(
   path_to_file(config.intel_dir, config.max_brightness_file), -- Intel.
   path_to_file(config.amd_dir, config.max_brightness_file), -- AMD.
   path_to_file(utils.scandir(config.backlight_path)[3], config.max_brightness_file) -- Fallback (brute-read anything from backlight dir).
)

-- Define widget to be used.
if config.show_progressbar then
   brightness.widget = wibox.widget(ui.bar)
else
   brightness.widget = wibox.widget(ui.text)
end

brightness.widget.layout = wibox.layout.align.horizontal

-- Return current brightness value percentage.
function brightness.file_perc()
   return utils.percent(utils.read(brightness.file), brightness.max_value)
end

-- Return current absolute brightness value.
function brightness.current()
   if brightness.file then
      local cur = utils.read(brightness.file)
      if cur then
         if config.lightctl_use_percent ~= false then
            cur = brightness.file_perc()
         end
         return string.format('%.' .. config.lightctl_precision .. 'f', cur)
      end
   end
   return 'N/A'
end

-- Read max_brightness value.
if brightness.max_file then
   brightness.max_value = utils.read(brightness.max_file) or 'N/A' -- Fetch max brightness level.
else
   brightness.max_value = 'N/A'
end
brightness.step = config.lightctl_step * (tonumber(brightness.max_value) or 1) / 100 -- Absolute step from percentage value.

-- Update text.
function brightness.text_update()
   brightness.widget:set_markup_silently('<span color="' .. config.fg_color_normal .. '">' .. brightness.current() .. '</span>')
end

-- Update progressbar.
function brightness.bar_update()
   brightness.widget:set_value(brightness.current() / brightness.max_value)
   brightness.widget:set_markup_silently('<span color="' .. config.fg_color_normal .. '">' .. brightness.current() .. '</span>')
end

-- Update widget.
function brightness.update()
   if config.show_progressbar then
      brightness.bar_update()
   else
      brightness.text_update()
   end
end

function brightness.up()
   if config.use_light then
      utils.capture('light -rA ' .. brightness.step)
   else
      utils.write(brightness.file, brightness.current() + brightness.step)
   end
   brightness.update()
end

function brightness.down()
   if config.use_light then
      utils.capture('light -rU ' .. brightness.step)
   else
      utils.write(brightness.file, brightness.current() - brightness.step)
   end
   brightness.update()
end

function brightness.halfup()
   if config.use_light then
      utils.capture('light -rA ' .. brightness.step/2)
   else
      utils.write(brightness.file, brightness.current() + brightness.step)
   end
   brightness.update()
end

function brightness.halfdown()
   if config.use_light then
      utils.capture('light -rU ' .. brightness.step/2)
   else
      utils.write(brightness.file, brightness.current() - brightness.step)
   end
   brightness.update()
end

-- Returns whether current value + delta is in edge.
function is_edge(delta)
   function val_in_edge(val)
      if tonumber(val) < 0 then val = 0 end
      if tonumber(val) > tonumber(brightness.max_value) then val = tonumber(brightness.max_value) end

      local val_perc = utils.percent(val, tonumber(brightness.max_value))

      if val_perc <= config.lightctl_edge or 100-val_perc <= config.lightctl_edge then
         return true
      end
      return false
   end

   local val = brightness.current()
   local val_delta = brightness.current()+delta

   if val_in_edge(val) or val_in_edge(val_delta) then
      return true
   end
   return false
end

function brightness.logup()
   if is_edge(brightness.step) then
      brightness.halfup()
   else
      brightness.up()
   end
   brightness.update()
end

function brightness.logdown()
   if is_edge(-1*brightness.step) then
      brightness.halfdown()
   else
      brightness.down()
   end
   brightness.update()
end

function brightness.min()
   if config.use_light then
      utils.capture('light -rS ' .. 0)
   else
      utils.write(brightness.file, 0)
   end
   brightness.update()
end

function brightness.all()
   if config.use_light then
      utils.capture('light -rS ' .. brightness.max_value)
   else
      utils.write(brightness.file, brightness.max_value)
   end
   brightness.update()
end

function brightness.half()
   if config.use_light then
      utils.capture('light -rS ' .. brightness.max_value/2)
   else
      utils.write(brightness.file, brightness.max_value/2)
   end
   brightness.update()
end

function brightness.toggle()
   if tonumber(brightness.current()) ~= 0
   then
      brightness.min()
   else
      brightness.all()
   end
end

-- Mouse click events.
brightness.widget:buttons(awful.util.table.join(
                       awful.button({ }, 1, brightness.toggle),
                       awful.button({ }, 3, brightness.all),
                       awful.button({ }, 5, brightness.up),
                       awful.button({ }, 4, brightness.down)
                                         )
)

-- Initialize widget.
brightness.update()

return brightness
