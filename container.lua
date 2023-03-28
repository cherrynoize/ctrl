local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi   = require("beautiful.xresources").apply_dpi

local function container(widget, args)
    local args = args or {}
    local on_hover = args.on_hover 

    local _container = wibox.widget {
        {
            widget,
            left   = dpi(6) or args.margin_h,
            right  = dpi(6) or args.margin_h,
            top    = dpi(2) or args.margin_v,
            bottom = dpi(2) or args.margin_v,
            widget = wibox.container.margin
        },
            shape              = args.shape or beautiful.widget_shape,
            shape_border_color = args.border_color or beautiful.widget_border_color,
            shape_border_width = args.border_width or beautiful.widget_border_width,
            bg                 = args.bg or beautiful.bg,
            widget             = wibox.container.background
    }

    if on_hover then
        _container:connect_signal("mouse::enter", function (args)
            _container.bg = args.bg_focus or beautiful.bg_focus
        end)
        _container:connect_signal("mouse::leave",function ()
            _container.bg = args.bg_normal or beautiful.bg_normal
        end)
    end

    return wibox.widget {
        _container,
        valign="center",
        halign="center",
        widget=wibox.container.place
    }
end

return container
