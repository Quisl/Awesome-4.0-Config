local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local watch = require("awful.widget.watch")

system_widget = wibox.widget{
    font = "Play 9",
    widget = wibox.widget.textbox,
    markup = ""
}

watch(
    "python ".. configpath .."scripts/memory.py", 3,
    function(widget, stdout, stderr, exitreason, exitcode)
        system_widget.markup=stdout
    end
)
