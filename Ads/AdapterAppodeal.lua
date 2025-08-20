local M = { name="Appodeal" }

local appodeal = require("plugin.appodeal")

function M.init(options)
    assert(options.appKey, "options.appKey is required")

    appodeal.init(options.adListener, {
        appKey = options.appKey,
        testMode = options.testMode,
        smartBanners = options.smartBanners,
        bannerAnimation = options.bannerAnimation,
        childDirectedTreatment = options.childDirectedTreatment,
        customRules = options.customRules,
        supportedAdTypes = options.supportedAdTypes,
        disableWriteExternalPermissionCheck = options.disableWriteExternalPermissionCheck,
        disableNetworks = options.disableNetworks,
        disableAutoCacheForAdTypes = options.disableAutoCacheForAdTypes,
    })
end

function M.load(adUnitType)
    appodeal.load(adUnitType)
end

function M.isLoaded(adUnitType)
    return appodeal.isLoaded(adUnitType)
end

function M.show(adUnitType, params)
    params = params or { yAlign="bottom", placement=nil }
    appodeal.show(adUnitType, { yAlign=params.yAlign, placement=params.placement })
end

function M.hide(adUnitType)
    appodeal.hide(adUnitType)
end

return M