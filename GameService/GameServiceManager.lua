local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")

local gameServiceList = {
    android = "Libs.GameService.PlayServices",
    ios ="Libs.GameService.GameCenter",
}
local gameService = nil
local isInit = false


function M.init(options)
    options = options or { android=true, ios=true }

    if not isDevice then
        return
    end

    if not options.supportedPlatforms[platform] then
        return
    end

    gameService = gameServiceList[platform]

    if gameService then
        gameService = require(gameService)
        gameService.init()

        isInit = true
    end
end

function M.login(listener)
    if isInit then
        gameService.login(nil, listener)
    end
end

function M.logout()
    if isInit then
        gameService.logout()
    end
end

function M.isConnected(listener)
    if isInit then
        gameService.isConnected(listener)
    end
end

function M.showLeaderboards(category, listener)
    if isInit then
        gameService.showLeaderboards(category, listener)
    end
end

function M.showAchievements(listener)
    if isInit then
        gameService.showAchievements(listener)
    end
end

function M.updateLeaderboards(id, score, listener)
    if isInit then
        gameService.updateLeaderboards(id, score, listener)
    end
end

function M.unlockAchievements(id, percentComplete, listener)
    if isInit then
        gameService.unlockAchievements(id, percentComplete, listener)
    end
end

function M.loadCurrentPlayer(listener)
    if isInit then
        gameService.loadCurrentPlayer(listener)
    end
end

return M
