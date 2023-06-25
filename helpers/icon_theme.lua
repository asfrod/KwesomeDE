-------------------------------------------
-- @author https://github.com/Kasper24
-- @copyright 2021-2022 Kasper24
-------------------------------------------
local lgi = require("lgi")
local Gio = lgi.Gio
local DesktopAppInfo = Gio.DesktopAppInfo
local AppInfo = Gio.DesktopAppInfo
local Gtk = lgi.require("Gtk", "3.0")
local beautiful = require("beautiful")
local string = string
local ipairs = ipairs

local ICON_SIZE = 48
local GTK_THEME = Gtk.IconTheme.get_default()

local _icon_theme = {}

function _icon_theme.choose_icon(icons_names, icon_theme, icon_size)
    if icon_theme then
        GTK_THEME = Gtk.IconTheme.new()
        Gtk.IconTheme.set_custom_theme(GTK_THEME, icon_theme);
    end
    if icon_size then
        ICON_SIZE = icon_size
    end

    local icon_info = GTK_THEME:choose_icon(icons_names, ICON_SIZE, 0);
    if icon_info then
        local icon_path = icon_info:get_filename()
        if icon_path then
            return icon_path
        end
    end

    return nil
end

function _icon_theme.get_gicon_path(gicon, icon_theme, icon_size)
    if gicon == nil then
        return ""
    end

    if icon_theme then
        GTK_THEME = Gtk.IconTheme.new()
        Gtk.IconTheme.set_custom_theme(GTK_THEME, icon_theme);
    end
    if icon_size then
        ICON_SIZE = icon_size
    end

    local icon_info = GTK_THEME:lookup_by_gicon(gicon, ICON_SIZE, 0);
    if icon_info then
        local icon_path = icon_info:get_filename()
        if icon_path then
            return icon_path
        end
    end

    return nil
end

function _icon_theme.get_icon_path(icon_name, icon_theme, icon_size)
    if icon_theme then
        GTK_THEME = Gtk.IconTheme.new()
        Gtk.IconTheme.set_custom_theme(GTK_THEME, icon_theme);
    end
    if icon_size then
        ICON_SIZE = icon_size
    end

    local icon_info = GTK_THEME:lookup_icon(icon_name, ICON_SIZE, 0)
    if icon_info then
        local icon_path = icon_info:get_filename()
        if icon_path then
            return icon_path
        end
    end

    return nil
end

function _icon_theme.get_app_icon_path(icon_name, icon_theme, icon_size)
    return _icon_theme.get_icon_path(icon_name, icon_theme, icon_size) or
            _icon_theme.choose_icon({"window", "window-manager", "xfwm4-default", "window_list"})
end

function _icon_theme:get_app_font_icon(...)
    local args = { ... }

    for _, arg in ipairs(args) do
        if arg then
            arg = arg:lower()
            arg = arg:gsub("_", "")
            arg = arg:gsub("%s+", "")
            arg = arg:gsub("-", "")
            arg = arg:gsub("%.", "")
            local icon = beautiful.app_icons[arg]
            if icon then
                return icon
            end
        end
    end

    return beautiful.icons.window
end

return _icon_theme
