local wibox = require("wibox")
local widgets = require("ui.widgets")
local beautiful = require("beautiful")
local text_input = require("ui.apps.settings.text_input")
local radio_group  = require("ui.apps.settings.radio_group")
local weather_daemon = require("daemons.web.weather")
local dpi = beautiful.xresources.apply_dpi
local setmetatable = setmetatable

local openweather = {
    mt = {}
}

local function new()
    local api_key_text_input = text_input {
        icon = beautiful.icons.lock,
        placeholder = "API Key:",
        initial = weather_daemon:get_api_key()
    }

    local latitude_text_input = text_input {
        icon = beautiful.icons.location_dot,
        placeholder =  "Latitude:",
        initial = weather_daemon:get_latitude()
    }

    local longitude_text_input = text_input {
        icon = beautiful.icons.location_dot,
        placeholder = "Longitude:",
        initial = weather_daemon:get_longitude()
    }

    local unit_radio_group = radio_group {
        forced_height = dpi(200),
        title = "Unit:",
        on_changed = function(id)
            weather_daemon:set_unit(id)
            weather_daemon:refresh()
        end,
        values = {
            {
                id = "metric",
                label = "Metric",
                color = beautiful.colors.background,
                check_color = beautiful.icons.computer.color
            },
            {
                id = "imperial",
                label = "Imperial",
                color = beautiful.colors.background,
                check_color = beautiful.icons.computer.color
            },
            {
                id = "standard",
                label = "Standard",
                color = beautiful.colors.background,
                check_color = beautiful.icons.computer.color
            }
        }
    }

    api_key_text_input:connect_signal("unfocus", function(self, context, text)
        weather_daemon:set_api_key(text)
        weather_daemon:refresh()
    end)

    latitude_text_input:connect_signal("unfocus", function(self, context, text)
        weather_daemon:set_latitude(text)
        weather_daemon:refresh()
    end)

    longitude_text_input:connect_signal("unfocus", function(self, context, text)
        weather_daemon:set_longitude(text)
        weather_daemon:refresh()
    end)

    return wibox.widget {
        layout = wibox.layout.overflow.vertical,
        scrollbar_widget = widgets.scrollbar,
        scrollbar_width = dpi(10),
        step = 50,
        spacing = dpi(15),
        api_key_text_input,
        longitude_text_input,
        latitude_text_input,
        unit_radio_group
    }
end

function openweather.mt:__call()
    return new()
end

return setmetatable(openweather, openweather.mt)