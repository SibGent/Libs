local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local gameAnalytics

local isInit
local currencyList
local itemList

-- { Clicked, Show, FailedShow, RewardReceived, Request or Loaded }
local actionEnum = {
    clicked = "Clicked",
    displayed = "Show",
    shown = "Show",
    failed = "FailedShow",
    dataReceived = "RewardReceived",
    playbackEnded = "RewardReceived",
}
local typeEnum = {
    banner = "Banner",
    interstitial = "Interstitial",
    rewardedVideo = "RewardedVideo",
}

local isPlatformAllowed
, cleanOptions
, checkCurrency
, checkItem


function M.init(options)
    if isDevice then
        if isPlatformAllowed(options) then
            isInit = true
            currencyList = options.currencyList or {}
            itemList = options.itemList or {}

            cleanOptions(options)
            gameAnalytics = require("plugin.gameanalytics_v2")
            gameAnalytics.configureBuild(system.getInfo("appVersionString"))
            gameAnalytics.configureAvailableResourceCurrencies(currencyList)
            gameAnalytics.configureAvailableResourceItemTypes(itemList)
            gameAnalytics.initialize(options)
        end
    end
end


function M.selectContent(...)
    if not isInit then
        return
    end

    local value, arg1, arg2, arg3

    if type(arg[1]) == "number" then
        value = arg[1]
        arg1 = arg[2]
        arg2 = arg[3] and ":" .. arg[3] or ""
        arg3 = arg[4] and ":" .. arg[4] or ""
    else
        arg1 = arg[1]
        arg2 = arg[2] and ":" .. arg[2] or ""
        arg3 = arg[3] and ":" .. arg[3] or ""
    end

    gameAnalytics.addDesignEvent {
        eventId = arg1 .. arg2 .. arg3,
        value = value
    }
end


function M.addCurrency(currency, amount, item_type, item_id)
    if not isInit then
        return
    end

    checkCurrency(currency)
    checkItem(item_type)

    gameAnalytics.addResourceEvent({
        flowType = "Source",
        currency = currency,
        amount = amount,
        itemType = item_type,
        itemId = item_id
    })
end


function M.subCurrency(currency, amount, item_type, item_id)
    if not isInit then
        return
    end

    checkCurrency(currency)
    checkItem(item_type)

    gameAnalytics.addResourceEvent({
        flowType = "Sink",
        currency = currency,
        amount = amount,
        itemType = item_type,
        itemId = item_id
    })
end


function M.trackAd(sdkName, placement, type, action)
    if not isInit then
        return
    end

    action = actionEnum[action]
    type = typeEnum[type]

    if action == nil or type == nil then
        return
    end

    gameAnalytics.addAdEvent({
        adSdkName = sdkName,
        adPlacement = placement,
        adType = type,
        adAction = action,
    })
end


function M.trackProgress(state, ...)
    if not isInit then
        return
    end

    local score, arg1, arg2, arg3

    if type(arg[1]) == "number" then
        score = arg[1]
        arg1 = arg[2] and tostring(arg[2])
        arg2 = arg[3] and tostring(arg[3])
        arg3 = arg[4] and tostring(arg[4])
    else
        arg1 = arg[1] and tostring(arg[1])
        arg2 = arg[2] and tostring(arg[2])
        arg3 = arg[3] and tostring(arg[3])
    end

    gameAnalytics.addProgressionEvent({
        progressionStatus = state,
        score = score,
        progression01 = arg1,
        progression02 = arg2,
        progression03 = arg3,
    })
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
    options.currencyList = nil
    options.itemList = nil
end

function checkCurrency(currency)
    local hasCurrency = false

    for i = 1, #currencyList do
        if currency == currencyList[i] then
            return
        end
    end

    if not hasCurrency then
        error("Currency " .. currency .. " is not init")
    end
end

function checkItem(item)
    local hasItem = false

    for i = 1, #itemList do
        if item == itemList[i] then
            return
        end
    end

    if not hasItem then
        error("Item " .. item .. " is not init")
    end
end

return M
