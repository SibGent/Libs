local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")

local gameServiceList = {
    android = "Libs.PlayServices",
    ios ="Libs.GameCenter",
}
local gameService = nil
local isInit = false


function M.init()
    if not isDevice then
        return
    end

    gameService = gameServiceList[platform]

    if gameService then
        gameService = require(gameService)
        isInit = true
    end
end

function M.login(listener)
    if isInit then
        gameService.login(userInitiated, listener)
    end
end

function M.logout()
    if isInit then
        gameService.logout()
    end
end

function M.isConnected()
    if isInit then
        return gameService.isConnected()
    end
end

function M.showLeaderboards(listener)
    if isInit then
        gameService.showLeaderboards(listener)
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

return M
