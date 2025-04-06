local M = {}

local gameNetwork = require("gameNetwork")

local isActive

local enforceLogin

function M.init()
end

function M.login(userInitiated, listener)
    gameNetwork.init("gamecenter", function(event)
        if event.data then
            isActive = true

            if listener then
                listener()
            end
        else
            print(event.errorCode, event.errorMessage)
        end
    end)
end

function M.logout()
end

function M.isConnected(listener)
    listener({
        name = "isConnected",
        isConnected = isActive,
    })
end

function M.showLeaderboards(category, listener)
    enforceLogin(function()
        gameNetwork.show("leaderboards", {
            leaderboard = {
                category = category,
                timeScope = "AllTime",
            },
            listener = listener
        })
    end)
end

function M.updateLeaderboards(id, score, listener)
    enforceLogin(function()
        gameNetwork.request("setHighScore", {
            localPlayerScore = {
                category = id,
                value = score,
            },
            listener = listener
        })
    end)
end

function M.showAchievements(listener)
    enforceLogin(function()
        if listener then
            listener()
        end

        gameNetwork.show("achievements", { leaderboard = {timeScope="AllTime"} })
    end)
end

function M.unlockAchievements(id, percentComplete, listener)
    enforceLogin(function()
        gameNetwork.request("unlockAchievement", {
            achievement = {
                identifier = id,
                percentComplete = percentComplete,
                showsCompletionBanner = true
            },
            listener = listener
        })
    end)
end

function M.loadCurrentPlayer(listener)
    enforceLogin(function()
        gameNetwork.request( "loadLocalPlayer", { listener=listener } )
    end)
end

-- private
function enforceLogin(listener)
	if not isActive then
		M.login(nil, listener)
	else
		listener()
	end
end

return M
