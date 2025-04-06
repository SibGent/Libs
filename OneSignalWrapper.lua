local M = {}

local json = require("json")

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local OneSignal = nil

local isInit

local isPlatformAllowed
, cleanOptions
, onSuccess
, onFailure

function M.init(options)
    if isDevice then
        if isPlatformAllowed(options) then
            isInit = true

            cleanOptions(options)
            OneSignal = require("plugin.OneSignal")
            OneSignal.Init(options.appId, options.googleProjectNumber, options.onCallback)
        end
    end
end

function M.setLogLevel(logLevel, visualLevel)
    if not isInit then
        return
    end

    OneSignal.SetLogLevel(logLevel, visualLevel)
end

function M.setSubscription(state)
    if not isInit then
        return
    end

    OneSignal.SetSubscription(state)
end

function M.postNotification(notification)
    if not isInit then
        return
    end

    OneSignal.PostNotification(notification, onSuccess, onFailure)
end

function M.IdsAvailableCallback(IdsAvailable)
    if not isInit then
        return
    end

    OneSignal.IdsAvailableCallback(IdsAvailable)
end

function M.clearAllNotifications()
    if not isInit then
        return
    end

    OneSignal.ClearAllNotifications()
end

function M.sendTag(key, value)
    if not isInit then
        return
    end

    OneSignal.SendTag(key, value)
end

function M.sendTags(tags)
    if not isInit then
        return
    end

    OneSignal.SendTags(tags)
end

function M.deleteTag(key)
    if not isInit then
        return
    end

    OneSignal.DeleteTag(key)
end

function M.deleteTags(tags)
    if not isInit then
        return
    end

    OneSignal.DeleteTags(tags)
end

-- private
function isPlatformAllowed(options)
    local platformList = options.platformList
    local isAllowed = false

    for i = 1, #platformList do
        if platform == platformList[i] then
            isAllowed = true
            break
        end
    end

    return isAllowed
end

function cleanOptions(options)
    options.platformList = nil
end

function onSuccess(jsonData)
    print("onSuccess ", json.encode(jsonData))
end

function onFailure(jsonData)
    print("onFailure ", json.encode(jsonData))
end

return M
