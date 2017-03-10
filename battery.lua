--[[The MIT License (MIT)

Modified by Jonas 'Quisl' Rabe
Original from Copyright (c) 2017 streetturtle ( https://github.com/streetturtle/AwesomeWM )

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local path_to_icons = iconpath

battery_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
        resize = false
    },
    layout = wibox.container.margin(brightness_icon, 5, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end
}

watch(
    "acpi", 5,
    function(widget, stdout, stderr, exitreason, exitcode)
        local batteryType
        local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d%d)%%,? ?.*')
        local charge = tonumber(charge_str)
        if (charge >= 0 and charge < 15) then
            batteryType="battery-empty%s-symbolic"
            show_battery_warning()
        elseif (charge >= 15 and charge < 40) then batteryType="battery-caution%s-symbolic"
        elseif (charge >= 40 and charge < 60) then batteryType="battery-low%s-symbolic"
        elseif (charge >= 60 and charge < 80) then batteryType="battery-good%s-symbolic"
        elseif (charge >= 80 and charge <= 100) then batteryType="battery-full%s-symbolic"
        end
        if status == 'Charging' then
            batteryType = string.format(batteryType,'-charging')
        else
            batteryType = string.format(batteryType,'')
        end
        battery_widget.image = path_to_icons .. batteryType .. ".svg"
    end
)
function show_battery_status()
    awful.spawn.easy_async([[bash -c 'acpi']],
        function(stdout, stderr, reason, exit_code)
            battery_widget_notification = naughty.notify{
                text = stdout,
                title = "Battery status",
                timeout = 5, hover_timeout = 0.0,
                width = 200,
            }
        end
    )
end
battery_widget:connect_signal("mouse::enter", function() show_battery_status() end)

function show_battery_warning()
    naughty.notify{
    icon = iconpath.."battery-low-symbolic.svg",
    icon_size=100,
    text = "Huston, we have a problem",
    title = "Battery is dying",
    timeout = 5, hover_timeout = 0.5,
    position = "bottom_right",
    bg = "#F06060",
    fg = "#EEE9EF",
    width = 300,
}
end
battery_widget:connect_signal("mouse::leave",
    function() naughty.destroy(battery_widget_notification)
end)
