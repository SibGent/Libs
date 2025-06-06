local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local plugin = nil
local isInit = false

local adAdapterInterface = {
    "init",
    "load",
    "isLoaded",
    "show",
    "hide"
}

local supportedPlugins = {
    ["admob"] = "Libs.Ads.AdapterAdmob",
    ["appodeal"] = "Libs.Ads.AdapterAppodeal",
}

local delayAdTable = {
    ["interstitial"] = 0,
    ["rewardedVideo"] = 0,
}
local delayAdTime = 60 -- in seconds

local eventTable = {}

local isPlatformAllowed
, isTurnOff
, getAppKey
, adListener
, checkOptions
, checkInterface
, executeEventTable

function M.init(options)
    checkOptions(options)
    options.adListener = adListener
    options.appKey = getAppKey(options)

    if isDevice then
        if isPlatformAllowed(options) and not isTurnOff(options) then
            plugin = require(supportedPlugins[options.plugin])
            checkInterface(plugin)
            plugin.init(options)
        end
    end
end

function M.load(adType, params)
    if not isInit then
        return
    end

    plugin.load(adType, params)
end

function M.canShow(adType)
    if not isInit then
        return
    end

    local shownTime = delayAdTable[adType] or 0

    if os.time() - shownTime < delayAdTime then
        return false
    end

    return true
end

function M.isLoaded(adType)
    if not isInit then
        return
    end

    return plugin.isLoaded(adType)
end

function M.show(adType, params)
    if not isInit then
        return
    end

    plugin.show(adType, params)
end

function M.hide(adType)
    if not isInit then
        return
    end

    plugin.hide(adType)
end

function M.addEventListener(listener)
    eventTable[1 + #eventTable] = listener
end

function M.removeEventListener(listener)
    for i, tableListener in pairs(eventTable) do
        if tableListener == listener then
            eventTable[i] = nil
            break
        end
    end
end

function isPlatformAllowed(options)
    local platformList = options.platformList
    local isAllowed = false

    for i = 1, #platformList do
        if platform == platformList[i] then
            isAllowed = true
            break
        end
    end

    options.platformList = nil

    return isAllowed
end

function isTurnOff(options)
    return (options.supportedAdTypes == "nil")
end

function getAppKey(options)
    local appKey = options[platform] or ""
    options.android = nil
    options.ios = nil

    return appKey
end

function adListener(event)
    if event.phase == "init" then
       isInit = true
    
    elseif event.phase == "closed" then
        delayAdTable[event.type] = os.time()
    end

    executeEventTable(event)
end

function checkOptions(options)
    assert(options, "argument #1 is required(table)")
    if type(options) ~= "table" then
        error("argument #1 is not table value")
    end
    assert(options.plugin, "options.plugin is required")
    assert(supportedPlugins[options.plugin], string.format("%s is not supported", options.plugin))
end

function checkInterface(pluginAdapter)
    for _, functionId in pairs(adAdapterInterface) do
        if type(pluginAdapter[functionId]) ~= "function" then
            local pluginName = pluginAdapter.name or "unknown plugin"
            local errorMessage = string.format("%s function '%s' is not is not implemented", pluginName, functionId)
            error(errorMessage)
        end
    end
end

function executeEventTable(event)
    for i = 1, #eventTable do
        eventTable[i](event)
    end
end

return M