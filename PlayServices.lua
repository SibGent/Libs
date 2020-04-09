local M = {}

local gpgs = require("plugin.gpgs.v2")

local enforceLogin


function M.login(userInitiated, listener)
	gpgs.login({
		userInitiated = userInitiated or true,
		listener = listener,
	})
end

function M.logout()
	gpgs.logout()
end

function M.isConnected()
	return gpgs.isConnected()
end

function M.showLeaderboards(listener)
	enforceLogin(gpgs.leaderboards.show)
end

function M.showAchievements(listener)
end

function M.updateLeaderboards(id, score, listener)
	if gpgs.isConnected() then
		gpgs.leaderboards.submit({
			leaderboardId = id,
			score = score,
			listener = listener,
		})
	end
end

function M.unlockAchievements(id, percentComplete, listener)
end

-- private
function enforceLogin(listener)
	if not gpgs.isConnected() then
		M.login(true, listener)
	else
		listener()
	end
end

return M
