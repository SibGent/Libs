local AdManager = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local appodeal = nil
local isInit = false
local isBannerShown = false

local eventTable = {}

local isPlatformAllowed
, getAppKey
, adListener
, rewardedListener
, executeEventTable

function AdManager.init(options)
    if isDevice then
        if isPlatformAllowed(options) then
            options.appKey = getAppKey(options)

            appodeal = require "plugin.appodeal"
            appodeal.init(adListener, options)
        end
    end
end

function AdManager.addEventListener(listener)
    eventTable[1 + #eventTable] = listener
end

function AdManager.removeEventListener(listener)
    for i = 1, #eventTable do
        if eventTable[i] == listener then
            eventTable[i] = nil
            break
        end
    end
end

function AdManager.isLoaded(adUnitType)
    if not isInit then
        return
    end

    return appodeal.isLoaded(adUnitType)
end

function AdManager.showBanner(position)
    if not isInit then
        return
    end

    appodeal.show("banner", {yAlign=position})
end

function AdManager.hideBanner()
    if not isInit then
        return
    end

    appodeal.hide("banner")
end

function AdManager.isBannerShown()
    return isBannerShown
end

function AdManager.showInterstitial()
    if not isInit then
        return
    end

    appodeal.show("interstitial")
end

function AdManager.showRewardedVideo(listener)
    if not isInit then
        return
    end

    rewardedListener = listener
    appodeal.show("rewardedVideo")
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

function getAppKey(options)
    local appKey = options[platform] or ""
    options.android = nil
    options.ios = nil

    return appKey
end

function adListener(event)
    if event.phase == "init" then
        isInit = true
    end

    if event.type == "banner" then
        if event.phase == "displayed" then
            isBannerShown = true
        end

        if event.phase == "hidden" then
            isBannerShown = false
        end
    end

    if event.type == "rewardedVideo" then
        if event.phase == "playbackEnded" then
            if rewardedListener then
                rewardedListener()
            end
        end
    end

    executeEventTable(event)
end

function executeEventTable(event)
    for i = 1, #eventTable do
        eventTable[i](event)
    end
end

return AdManager
