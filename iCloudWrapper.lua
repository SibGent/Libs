local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local iCloud
local isInit

function M.init()
    if isDevice then
        if platform == "ios" then
            iCloud = require("plugin.iCloud")
            isInit = true
        end
    end
end

function M.setKVSListener(listener)
    if not isInit then
        return
    end

    iCloud.setKVSListener(listener)
end

function M.set(key, value)
    if not isInit then
        return
    end

    iCloud.set(key, value)
end

function M.get(key)
    if not isInit then
        return
    end

    return iCloud.get(key)
end

function M.delete(key)
    if not isInit then
        return
    end

    iCloud.delete(key)
end

function M.identityToken()
    if not isInit then
        return
    end

    return iCloud.identityToken()
end

function M.synchronize()
    if not isInit then
        return
    end

    iCloud.synchronize()
end

function M.table()
    if not isInit then
        return
    end

    return iCloud.table()
end

return M
