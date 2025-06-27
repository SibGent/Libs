local M = {}

local plugin = nil
local isDevice = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")

function M.init(options)
    if not isDevice then
        return
    end

    options = options or { supportedPlatforms = { android = true, ios = true } }
    local supportedPlatforms = options.supportedPlatforms
    if supportedPlatforms[platform] then
        plugin = require("plugin.notifications.v2")
    end
end

function M.registerForPushNotifications()
    if plugin == nil then
        return
    end

    plugin.registerForPushNotifications()
end

function M.scheduleLocalNotification(time, options)
    if plugin == nil then
        return nil
    end

    if type(time) ~= "number" and type(time) ~= "table" then
        print("ERROR: 'time' must be a number (seconds) or a table (UTC time)")
        return nil
    end

    if type(time) == "table" then
        local requiredFields = { "year", "month", "day", "hour", "min", "sec" }
        for _, field in ipairs(requiredFields) do
            if not time[field] then
                print("ERROR: UTC time table missing required field: " .. field)
                return nil
            end
        end
    end

    local notificationOptions = {}
    if options then
        if type(options.alert) == "string" then
            notificationOptions.alert = options.alert
        elseif type(options.alert) == "table" then
            notificationOptions.alert = {
                title = options.alert.title or "",
                body = options.alert.body or ""
            }
        end
        notificationOptions.badge = (platform == "ios" and options.badge) or nil
        notificationOptions.sound = options.sound or nil
        notificationOptions.custom = options.custom or {}
    end

    if platform == "ios" and system.getInfo("appState") == "suspended" then
        print("WARNING: Scheduling notifications on iOS during app suspend may cause a crash")
    end

    local notificationId = plugin.scheduleNotification(time, notificationOptions)
    return notificationId
end

function M.cancelNotification(notificationId)
    if plugin == nil then
        return
    end

    if notificationId then
        plugin.cancelNotification(notificationId)
    end
end

function M.cancelAllNotifications()
    if plugin == nil then
        return
    end

    plugin.cancelNotification()
end

function M.subscribe(topic)
    if plugin == nil then
        return
    end

    if type(topic) ~= "string" then
        print("ERROR: 'topic' must be a string")
        return
    end

    plugin.subscribe(topic)
end

function M.unsubscribe(topic)
    if plugin == nil then
        return
    end

    if type(topic) ~= "string" then
        print("ERROR: 'topic' must be a string")
        return
    end

    plugin.unsubscribe(topic)
end

function M.getDeviceToken()
    if plugin == nil then
        return nil
    end

    return plugin.getDeviceToken()
end

function M.areNotificationsEnabled()
    if plugin == nil then
        return false
    end

    return plugin.areNotificationsEnabled()
end

return M