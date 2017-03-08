local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local watch = require("awful.widget.watch")

--local system_icon = wibox.widget {
--    {
--      image = "/usr/share/icons/Adwaita/scalable/status/dialog-information-symbolic.svg",
--    	resize = false,
--      widget = wibox.widget.imagebox,
--    },
--    layout = wibox.container.margin(brightness_icon, 5, 0, 2),
--}

local text_widget = wibox.widget{
    font = "Play 9",
    widget = wibox.widget.textbox,
    markup = ""
}


system_widget = wibox.widget{
--    system_icon,
    text_widget,
    layout = wibox.layout.fixed.horizontal,
}

watch(
    "python ".. configpath .."memory.py", 3,
    function(widget, stdout, stderr, exitreason, exitcode)
--        local cpu_level = tonumber(string.format("%.1f", stdout))
        --text_widget:set_text(stdout)
        text_widget.markup=stdout
--                text_widget:set_text(cpu_level.."% CPU")
    end
)
