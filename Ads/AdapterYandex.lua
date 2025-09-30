local M = { name="Yandex" }

local ya = require("plugin_yandex_games")

function M.init(options)
    ya.setAdListener(options.adListener)
    options.adListener({phase="init"})
end

function M.load()
end

function M.isLoaded()
    return true
end

function M.show(adType)
    if adType == "interstitial" then
        ya.showFullscreenAdv()
    elseif adType == "rewardedVideo" then
        ya.showRewardedVideo()
    end
end

function M.hide()
end

return M