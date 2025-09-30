local M = {}

local ya = require("plugin_yandex_games")

local enforceLogin

function M.init()
end

function M.login(userInitiated, listener)
end

function M.logout()
end

function M.isConnected(listener)
    listener({
        name = "isConnected",
        isConnected = true,
    })

    return true
end

function M.showLeaderboards(listener)
end

function M.showAchievements(listener)
end

function M.updateLeaderboards(id, score, listener)
    ya.setLeaderboardScore(id, score)
end

function M.unlockAchievements(id, percentComplete, listener)
end

function M.loadCurrentPlayer(listener)
end

-- private
function enforceLogin(listener)
    -- if not ya.isConnected() then
    --     M.login(true, listener)
    -- else
    --     listener()
    -- end
end

return M
