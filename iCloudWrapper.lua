local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform  = system.getInfo("platform")
local iCloud    = nil
local isInit    = false

local mock = {
    set = function(...) end,
    get = function(...) return nil end,
    delete = function(...) end,
    identityToken = function() return nil end,
    synchronize = function() end,
    table = function() return {} end,
    setKVSListener = function(...) end
}

function M.init()
    if isDevice and platform == "ios" then
        local success, plugin = pcall(require, "plugin.iCloud")
        if success and plugin then
            iCloud = plugin
            isInit = true
        else
            iCloud = mock
        end
    else
        iCloud = mock
    end
end

function M.setKVSListener(listener)
    iCloud.setKVSListener(listener)
end

function M.set(key, value)
    iCloud.set(key, value)
end

function M.get(key)
    return iCloud.get(key)
end

function M.delete(key)
    iCloud.delete(key)
end

function M.identityToken()
    return iCloud.identityToken()
end

function M.synchronize()
    iCloud.synchronize()
end

function M.table()
    return iCloud.table()
end

return M
