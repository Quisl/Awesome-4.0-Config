--[[The MIT License (MIT)

Copyright (c) 2017

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
local http = require("socket.http")
local json = require("json")
local naughty = require("naughty")


local path_to_icons = iconpath

-- Grab open weather map key from file:
-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

if file_exists(pathToOpenmap) then
  filelines = lines_from(pathToOpenmap)
  if filelines[0] ~= nil then
      open_map_key = filelines[0]
  else
      open_map_key = filelines[1]
  end
end

if not (open_map_key == nil or open_map_key == '') then

local icon_widget = wibox.widget {
    {
        id = "icon",
        resize = false,
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(brightness_icon, 5, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end,
}

local text_widget = wibox.widget{
    font = "Play 9",
    widget = wibox.widget.textbox,
    text = ""
}

weather_widget = wibox.widget {
    icon_widget,
    text_widget,
    layout = wibox.layout.fixed.horizontal,
}

-- helps to map openWeatherMap icons to Arc icons
local icon_map = {
    ["01d"] = "weather-clear-symbolic.svg",
    ["02d"] = "weather-few-clouds-symbolic.svg",
    ["03d"] = "weather-clouds-symbolic.svg",
    ["04d"] = "weather-overcast-symbolic.svg",
    ["09d"] = "weather-showers-scattered-symbolic.svg",
    ["10d"] = "weather-showers-symbolic.svg",
    ["11d"] = "weather-storm-symbolic.svg",
    ["13d"] = "weather-snow-symbolic.svg",
    ["50d"] = "weather-fog-symbolic.svg",
    ["01n"] = "weather-clear-night-symbolic.svg",
    ["02n"] = "weather-few-clouds-night-symbolic.svg",
    ["03n"] = "weather-clouds-night-symbolic.svg",
    ["04n"] = "weather-overcast-symbolic.svg",
    ["09n"] = "weather-showers-scattered-symbolic.svg",
    ["10n"] = "weather-showers-symbolic.svg",
    ["11n"] = "weather-storm-symbolic.svg",
    ["13n"] = "weather-snow-symbolic.svg",
    ["50n"] = "weather-fog-symbolic.svg"
}

-- handy function to convert temperature from Kelvin to Celcius
function to_celcius(kelvin)
    return math.floor(tonumber(kelvin) - 273.15)
end

local weather_timer = timer({ timeout = 60 })
local resp

weather_timer:connect_signal("timeout", function ()
    local resp_json = http.request("http://api.openweathermap.org/data/2.5/weather?q=" .. city .."&appid=" .. open_map_key)
    if (resp_json ~= nil) then
        weather_widget.visible = true
        resp = json.decode(resp_json)
        icon_widget.image = path_to_icons .. icon_map[resp.weather[1].icon]
        text_widget:set_text(to_celcius(resp.main.temp) .. '°C')
    else
        weather_widget.visible = false
    end


end)
weather_timer:emit_signal("timeout")

weather_widget:connect_signal("mouse::enter", function()
    local winddirstring = ""
    if resp.wind.deg == nil or resp.wind.deg == '' then
      local winddirstring = "//"
    else
      winddir = tonumber(resp.wind.deg)
      if winddir <= 11.25 or winddir >= 348.75 then
        winddirstring = "N"
      elseif winddir < 33.75 or winddir > 11.25 then
        winddirstring = "NNE"
      elseif winddir < 56.25 or winddir > 33.75 then
        winddirstring = "NE"
      elseif winddir < 78.75 or winddir > 56.25 then
        winddirstring = "ENE"
      elseif winddir < 101.25 or winddir > 78.75 then
        winddirstring = "E"
      elseif winddir < 123.75 or winddir > 101.25 then
        winddirstring = "ESE"
      elseif winddir < 146.25 or winddir > 123.75 then
        winddirstring = "SE"
      elseif winddir < 168.75 or winddir > 146.25 then
        winddirstring = "SSE"
      elseif winddir < 191.25 or winddir > 168.75 then
        winddirstring = "S"
      elseif winddir < 213.75 or winddir > 191.25 then
        winddirstring = "SSW"
      elseif winddir < 236.25 or winddir > 213.75 then
        winddirstring = "SW"
      elseif winddir < 258.75 or winddir > 236.25 then
        winddirstring = "WSW"
      elseif winddir < 281.25 or winddir > 258.75 then
        winddirstring = "W"
      elseif winddir < 303.75 or winddir > 281.25 then
        winddirstring = "WNW"
      elseif winddir < 326.25 or winddir > 303.75 then
        winddirstring = "NW"
      elseif winddir < 348.75 or winddir > 326.25 then
        winddirstring = "NNW"
      end
    end
    weather_widget_nofity = naughty.notify{
        icon = path_to_icons .. icon_map[resp.weather[1].icon],
        icon_size=20,
        text = '<b>'.. resp.name .. ',' .. resp.sys.country ..
        '</b><br>' .. resp.coord.lat .. '°N ' .. resp.coord.lon .. '°E' ..
        '<br><b>Temperature: </b>' .. to_celcius(resp.main.temp) ..
        ' °C<br><b>Weather: </b>'.. resp.weather[1].description ..
        '<br><b>Humidity:</b> ' .. resp.main.humidity ..
        '%<br><b>Pressure: </b>' .. resp.main.pressure ..
        ' hPa<br><b>Wind: </b>' .. resp.wind.speed .. ' m/s to ' .. winddirstring ..
        '<br><b>Sunrise: </b>' .. os.date('%H:%M',resp.sys.sunrise) ..
        '<br><b>Sunset: </b>' .. os.date('%H:%M',resp.sys.sunset),
        timeout = 20, hover_timeout = 0.0,
        width = 200,
    }
end)
weather_widget:connect_signal("mouse::leave",
    function() naughty.destroy(weather_widget_nofity)
end)
end
