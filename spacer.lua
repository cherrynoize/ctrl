--[[
 ____
/ ___| _ __   __ _  ___ ___ _ __
\___ \| '_ \ / _` |/ __/ _ \ '__| - Simple separator widget for awesome wm. 
 ___) | |_) | (_| | (_|  __/ |    - https://github.com/cherrynoize/ctrl
|____/| .__/ \__,_|\___\___|_|    - cherry-noize
      |_|
]]--

-- Module imports.
local awful = require "awful"
local wibox = require "wibox"

-- Path to the widget or plugin directory where this
-- module is.
ctrl = "widgets.ctrl."

-- Import widget modules.
local config = require (ctrl .. ".config")

-- Initialize separator variable and id.
local sep = {}
sep.id = 1

sep.arator = wibox.widget {
   markup = config.spacectl_markup,
   align = config.spacectl_align,
   opacity = config.spacectl_opacity,
   left = config.spacectl_margin_left,
   right = config.spacectl_margin_right,
   top = config.spacectl_margin_top,
   bottom = config.spacectl_margin_bottom,
   widget = wibox.widget.textbox
}

function sep.switch(by)
   if config.sep_list[sep.id + by] then
      sep.id = sep.id + by
   else
      if sep.id > 1 then
         sep.id = 1
      else
         sep.id = #config.sep_list
      end
   end

   sep.update()
end

function sep.forward() sep.switch(1) end
function sep.back() sep.switch(-1) end

function sep.key(mod, key, f)
   if config.dynamic_sep then
      if not mod then mod = {modkey, "Control", "Shift"} end
      if not key then key = "s" end
      if f then
         return awful.key(mod, key, function() f() end)
      else
         return sep.forward
      end
   end
end

function sep.update()
   sep.arator:set_markup_silently("<span color='" .. config.spacectl_fg_color .. "'>" .. config.spacectl_prefix .. config.sep_list[sep.id] .. config.spacectl_suffix .. "</span>")
end

if config.dynamic_sep then
   -- Mouse click events.
   sep.arator:buttons(awful.util.table.join(
      awful.button({ }, 1, sep.forward),
      awful.button({ }, 3, sep.back),
      awful.button({ }, 5, sep.back),
      awful.button({ }, 4, sep.forward)
   ))
end

-- Initialize widget.
sep.update()

return sep
