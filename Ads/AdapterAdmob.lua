local M = { name="Admob" }

local admob = require("plugin.admob")

function M.init(options)
    assert(options.appId, "options.appId is required")

    admob.init(options.adListener, {
        appId = options.appId,
        testMode = options.testMode,
        videoAdVolume = options.videoAdVolume,
    })
end

function M.load(adType, params)
    admob.load(adType, params)
end

function M.isLoaded(adType)
    return admob.isLoaded(adType)
end

function M.show(adType, params)
    params = params or { y="bottom", bgColor=nil }
    admob.show(adType, { y=params.yAlign, bgColor=params.bgColor })
end

function M.hide()
    admob.hide()
end

return M