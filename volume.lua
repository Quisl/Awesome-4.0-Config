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

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local path_to_icons = iconpath

volume_widget = wibox.widget {
    {
        id = "icon",
   	image = path_to_icons .. "audio-volume-muted-symbolic.svg",
	resize = false,
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(brightness_icon, 5, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end
}

--allows control volume level by clicking on the widget to mute/unmute and
--scrolling when the cursor is over the widget

volume_widget:connect_signal("button::press", function(_,_,_,button)
    if (button == 4) then
        awful.spawn("amixer sset Master 5%+")
    elseif (button == 5) then
        awful.spawn("amixer sset Master 5%-")
    elseif (button == 1) then
        awful.spawn("amixer sset Master toggle")
    end
end)

watch(
    'amixer sget Master', 1,
    function(widget, stdout, stderr, reason, exit_code)
        local mute = string.match(stdout, "%[(o%D%D?)%]")
        local volume = string.match(stdout, "(%d?%d?%d)%%")
		volume = tonumber(string.format("% 3d", volume))
		local volume_icon_name
		if mute == "off" then volume_icon_name="audio-volume-muted-symbolic"
		elseif (volume >= 0 and volume < 25) then volume_icon_name="audio-volume-muted-symbolic"
		elseif (volume >= 25 and volume < 50) then volume_icon_name="audio-volume-low-symbolic"
		elseif (volume >= 50 and volume < 75) then volume_icon_name="audio-volume-medium-symbolic"
		elseif (volume >= 75 and volume <= 100) then volume_icon_name="audio-volume-high-symbolic"
		end
        volume_widget.image = path_to_icons .. volume_icon_name .. ".svg"
    end
)
