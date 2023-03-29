local wibox = require "wibox"
-- Import Ctrl modules
local config = require "ctrl.config"

local ui = {}

-- Text widget.
ui.text = {
   text   = '',
   font   = config.font,
   align  = config.align,
   widget = wibox.widget.textbox
}

-- Progressbar.
ui.bar = {
   max_value     = config.max_value,
   value         = config.value,
   forced_height = config.height,
   forced_width  = config.width,
   step          = config.step,
   paddings      = config.padding,
   border_width  = config.border_width,
   border_color  = config.border_color,
   paddings      = config.padding,
   margins       = config.margin,
   shape         = config.shape,
   bar_shape     = config.bar_shape,
   widget        = config.widget
}

return ui
