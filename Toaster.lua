local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local toast = nil

local isInit
local platformList

local isPlatformAllowed
, cleanOptions


function M.init(options)
    if isDevice then
        if isPlatformAllowed(options) then
            isInit = true

            cleanOptions(options)
            toast = require("plugin.toast")
        end
    end
end

function M.show(message, options)
    if not isInit then
        return
    end

    toast.show(message, options)
end

-- private
function isPlatformAllowed(options)
    local platformList = options.platformList
    local isAllowed = false

    for i = 1, #platformList do
        if platform == platformList[i] then
            isAllowed = true
            break
        end
    end

    return isAllowed
end

function cleanOptions(options)
    options.platformList = nil
end

return M
