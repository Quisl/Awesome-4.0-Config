local wibox = require("wibox")
local watch = require("awful.widget.watch")

local brightness_icon = wibox.widget {
    {
      image = iconpath.."/display-brightness-symbolic.svg",
    	resize = false,
      widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(brightness_icon, 5, 0, 2),
}

local brightness_text_widget = wibox.widget{
    font = "Play 9",
    widget = wibox.widget.textbox,
}

brightness_widget = wibox.widget {
    brightness_icon,
    brightness_text_widget,
    layout = wibox.layout.fixed.horizontal,
}

watch(
    "xbacklight -get", 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        local brightness_level = tonumber(string.format("%.0f", stdout))
        brightness_text_widget:set_text(brightness_level)
    end
)
