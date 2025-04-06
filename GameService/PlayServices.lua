local M = {}

local gpgs = require("plugin.gpgs.v3")

local enforceLogin


function M.init()
    gpgs.init()
end

function M.login(userInitiated, listener)
    gpgs.login({
        userInitiated = userInitiated or true,
        listener = listener,
    })
end

function M.logout()
    gpgs.logout()
end

function M.isConnected(listener)
    gpgs.isConnected(listener)
end

function M.showLeaderboards(listener)
    enforceLogin(gpgs.leaderboards.show)
end

function M.showAchievements(listener)
    enforceLogin(gpgs.achievements.show)
end

function M.updateLeaderboards(id, score, listener)
    gpgs.leaderboards.submit({
        leaderboardId = id,
        score = score,
        listener = listener,
    })
end

function M.unlockAchievements(id, percentComplete, listener)
end

function M.loadCurrentPlayer(listener)
end

-- private
function enforceLogin(listener)
    M.isConnected(function(event)
        if not event.isConnected then
            M.login(true, listener)
        else
            listener()
        end
    end)
end

return M
