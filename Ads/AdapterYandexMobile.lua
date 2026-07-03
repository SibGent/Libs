local M = { name="YandexMobileAds" }

local YandexMobileAds = require("plugin.YandexMobileAds")

local DEFAULT_AD_UNIT_IDS = {
    banner = "demo-banner-yandex",
    interstitial = "demo-interstitial-yandex",
    rewardedVideo = "demo-rewarded-yandex",
}

local loadedState = {
    banner = false,
    interstitial = false,
    rewardedVideo = false,
}

local configuredAdUnitIds = {}
local supportedAdTypes = {}
local bannerPosition = "top"
local isTestMode = false
local externalListener

local normalizeType
, normalizePhase
, cacheAdUnitIds
, cacheSupportedAdTypes
, preloadConfiguredAds
, loadBanner
, loadInterstitial
, loadRewarded
, debugLog
, onPluginEvent

function M.init(options)
    externalListener = options.adListener
    bannerPosition = options.bannerPosition or "top"
    isTestMode = options.testMode == true

    cacheAdUnitIds(options)
    cacheSupportedAdTypes(options.supportedAdTypes)

    YandexMobileAds.init(onPluginEvent)
    YandexMobileAds.initialize()
    YandexMobileAds.enableDebugErrorIndicator(isTestMode or options.enableDebugErrorIndicator == true)

    preloadConfiguredAds()
end

function M.load(adType, params)
    if adType == "banner" then
        loadBanner(params)
    elseif adType == "interstitial" then
        loadInterstitial()
    elseif adType == "rewardedVideo" then
        loadRewarded()
    end
end

function M.isLoaded(adType)
    return loadedState[adType] == true
end

function M.show(adType, params)
    if adType == "banner" then
        loadBanner(params)
    elseif adType == "interstitial" then
        loadedState.interstitial = false
        YandexMobileAds.showInterstitial()
    elseif adType == "rewardedVideo" then
        loadedState.rewardedVideo = false
        YandexMobileAds.showRewarded()
    end
end

function M.hide(adType)
    if adType == "banner" then
        debugLog("hide", adType)
        YandexMobileAds.hideBanner()
        loadedState.banner = false
    end
end

function debugLog(...)
    if not isTestMode then
        return
    end

    local parts = {"[YandexMobileAds]"}
    for i = 1, select("#", ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end

    print(table.concat(parts, " "))
end

function normalizeType(pluginType)
    if pluginType == "rewarded" then
        return "rewardedVideo"
    end

    return pluginType
end

function normalizePhase(pluginType, pluginPhase)
    if pluginType == "sdk" and pluginPhase == "initialized" then
        return "init"
    end

    if pluginType == "banner" and pluginPhase == "loaded" then
        return "displayed"
    end

    if pluginPhase == "shown" then
        if pluginType == "rewarded" then
            return "playbackBegan"
        end

        return "displayed"
    end

    if pluginPhase == "dismissed" then
        return "closed"
    end

    if pluginType == "rewarded" and pluginPhase == "rewarded" then
        return "playbackEnded"
    end

    return pluginPhase
end

function cacheAdUnitIds(options)
    if isTestMode then
        configuredAdUnitIds.banner = DEFAULT_AD_UNIT_IDS.banner
        configuredAdUnitIds.interstitial = DEFAULT_AD_UNIT_IDS.interstitial
        configuredAdUnitIds.rewardedVideo = DEFAULT_AD_UNIT_IDS.rewardedVideo
        return
    end

    configuredAdUnitIds.banner = options.bannerAdUnitId or options.bannerId
    configuredAdUnitIds.interstitial = options.interstitialAdUnitId or options.interstitialId
    configuredAdUnitIds.rewardedVideo = options.rewardedAdUnitId or options.rewardedId

    assert(configuredAdUnitIds.banner, "options.bannerAdUnitId is required when testMode=false")
    assert(configuredAdUnitIds.interstitial, "options.interstitialAdUnitId is required when testMode=false")
    assert(configuredAdUnitIds.rewardedVideo, "options.rewardedAdUnitId is required when testMode=false")
end

function cacheSupportedAdTypes(adTypes)
    supportedAdTypes = {}

    if type(adTypes) ~= "table" then
        supportedAdTypes.banner = true
        supportedAdTypes.interstitial = true
        supportedAdTypes.rewardedVideo = true
        return
    end

    for _, adType in pairs(adTypes) do
        supportedAdTypes[adType] = true
    end
end

function preloadConfiguredAds()
    if supportedAdTypes.interstitial then
        debugLog("preload", "interstitial", configuredAdUnitIds.interstitial)
        loadInterstitial()
    end

    if supportedAdTypes.rewardedVideo then
        debugLog("preload", "rewardedVideo", configuredAdUnitIds.rewardedVideo)
        loadRewarded()
    end
end

function loadBanner(params)
    local position = bannerPosition

    if type(params) == "table" then
        position = params.yAlign or params.position or position
    end

    debugLog("load", "banner", configuredAdUnitIds.banner, "position=" .. tostring(position))
    YandexMobileAds.loadBanner(configuredAdUnitIds.banner, { position = position })
end

function loadInterstitial()
    debugLog("load", "interstitial", configuredAdUnitIds.interstitial)
    YandexMobileAds.loadInterstitial(configuredAdUnitIds.interstitial)
end

function loadRewarded()
    debugLog("load", "rewardedVideo", configuredAdUnitIds.rewardedVideo)
    YandexMobileAds.loadRewarded(configuredAdUnitIds.rewardedVideo)
end

function onPluginEvent(event)
    local adType = normalizeType(event.type)
    local phase = normalizePhase(event.type, event.phase)

    debugLog(
        "event",
        "srcType=" .. tostring(event.type),
        "srcPhase=" .. tostring(event.phase),
        "type=" .. tostring(adType),
        "phase=" .. tostring(phase),
        "adUnitId=" .. tostring(event.adUnitId),
        "error=" .. tostring(event.errorMessage),
        "rewardAmount=" .. tostring(event.rewardAmount),
        "rewardType=" .. tostring(event.rewardType)
    )

    if adType == "interstitial" or adType == "rewardedVideo" then
        if event.phase == "loaded" then
            loadedState[adType] = true
        elseif event.phase == "shown" or event.phase == "dismissed" or event.phase == "failedToShow" then
            loadedState[adType] = false
        end
    elseif adType == "banner" then
        if event.phase == "failedToLoad" or event.phase == "closed" then
            loadedState.banner = false
        else
            loadedState.banner = true
        end
    end

    debugLog(
        "state",
        "banner=" .. tostring(loadedState.banner),
        "interstitial=" .. tostring(loadedState.interstitial),
        "rewardedVideo=" .. tostring(loadedState.rewardedVideo)
    )

    if type(externalListener) == "function" then
        event.type = adType
        event.phase = phase
        externalListener(event)
    end
end

return M
