local M = {}

local isDevice  = (system.getInfo("environment") == "device")
local platform = system.getInfo("platform")
local FirebaseAnalytics = nil

local isInit
local errorMessage

local isPlatformAllowed

function M.init(options)
    if isDevice then
        if isPlatformAllowed(options) then
            FirebaseAnalytics = require("plugin.googleAnalytics.v2")
            isInit, errorMessage = pcall(FirebaseAnalytics.init)
        end
    end
end

function M.selectContent(content_type, item_id)
    if not isInit then
        return
    end

    local params = {}
    params.content_type = content_type
    params.item_id = item_id

    FirebaseAnalytics.logEvent("select_content", params)
end

function M.addCurrency(currency, amount)
    if not isInit then
        return
    end

    local params = {}
    params.virtual_currency_name = currency
    params.value = amount

    FirebaseAnalytics.logEvent("earn_virtual_currency", params)
end

function M.subCurrency(currency, amount, item_name)
    if not isInit then
        return
    end

    local params = {}
    params.virtual_currency_name = currency
    params.value = amount
    params.item_name = item_name

    FirebaseAnalytics.logEvent("spend_virtual_currency", params)
end

function M.trackAd()
end

function M.trackProgress()
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
