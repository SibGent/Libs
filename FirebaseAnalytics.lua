local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local FirebaseAnalytics = nil

local isInit
local platformList

local isPlatformAllowed

local levelState = {
    start = "level_start",
    fail = "level_end",
    complete = "level_end",
}

local levelSuccess = {
    fail = 0,
    complete = 1,
}

function M.init(options)
    if isDevice then
        if isPlatformAllowed(options) then
            FirebaseAnalytics = require("plugin.firebaseAnalytics")
            isInit = pcall(FirebaseAnalytics.init)
        end
    end
end


function M.selectContent(...)
    if not isInit then
        return
    end

    local value, arg1, arg2, arg3

    if type(arg[1]) == "number" then
        value = arg[1]
        arg1 = arg[2]
        arg2 = arg[3]
        arg3 = arg[4]
    else
        arg1 = arg[1]
        arg2 = arg[2]
        arg3 = arg[3]
    end

    local params = {}
	params.content_type = arg1
	params.item_id = arg2

    FirebaseAnalytics.logEvent("select_content", params)
end


function M.setProgress(state, ...)
    if not isInit then
        return
    end

    local score, arg1, arg2, arg3

    if type(arg[1]) == "number" then
        score = arg[1]
        arg1 = arg[2] and tostring(arg[2]) or ""
        arg2 = arg[3] and tostring(arg[3]) or ""
        arg3 = arg[4] and tostring(arg[4]) or ""
    else
        arg1 = arg[1] and tostring(arg[1]) or ""
        arg2 = arg[2] and tostring(arg[2]) or ""
        arg3 = arg[3] and tostring(arg[3]) or ""
    end

    local params = {}
	params.level_name = arg1 .. ":" .. arg2
	params.success = levelSuccess[state]

    FirebaseAnalytics.logEvent(levelState[state], params)
end


function M.addResource(currency, amount, item_type, item_id)
    if not isInit then
        return
    end

    local params = {}
    params.virtual_currency_name = currency
    params.value = amount

    FirebaseAnalytics.logEvent("earn_virtual_currency", params)
end


function M.subResource(currency, amount, item_type, item_id)
    if not isInit then
        return
    end

    local params = {}
    params.item_name = item_id
    params.virtual_currency_name = currency
    params.value = amount

    FirebaseAnalytics.logEvent("spend_virtual_currency", params)
end


function M.purchaseItem(cart_type, item_type, item_id, amount, currency)
    if not isInit then
        return
    end

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

return M
