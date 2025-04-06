local M = {}

local analyticsList = {}

local interface = {
    "selectContent",
    "addCurrency",
    "subCurrency",
    "trackAd",
    "trackProgress",
}

local checkInterface
, execFunction

function M.init()
    for _, analytics in pairs(analyticsList) do
        checkInterface(analytics)

        local module = analytics["module"]
        local options = analytics["options"]

        if module then
            module.init(options)
        end
    end
end

function M.add(module, ...)
    analyticsList[1 + #analyticsList] = {
        module = require(module),
        options = ...,
    }
end

function M.selectContent(content_type, item_id)
    assert(content_type, "bad argument #1 to 'selectContent' (string expected, got no value)")
    assert(item_id, "bad argument #2 to 'selectContent' (string expected, got no value)")
    execFunction("selectContent", content_type, item_id)
end

function M.addCurrency(currency, amount)
    assert(currency, "bad argument #1 to 'addCurrency' (string expected, got no value)")
    assert(amount, "bad argument #2 to 'addCurrency' (number expected, got no value)")
    execFunction("addCurrency", currency, amount)
end

function M.subCurrency(currency, amount, item_name)
    assert(currency, "bad argument #1 to 'subCurrency' (string expected, got no value)")
    assert(amount, "bad argument #2 to 'subCurrency' (number expected, got no value)")
    assert(item_name, "bad argument #3 to 'subCurrency' (string expected, got no value)")
    execFunction("subCurrency", currency, amount, item_name)
end

function M.trackAd(sdkName, placement, type, action)
    assert(sdkName, "bad argument #1 to 'trackAd' (string expected, got no value)")
    assert(placement, "bad argument #2 to 'trackAd' (number expected, got no value)")
    assert(type, "bad argument #3 to 'trackAd' (string expected, got no value)")
    assert(action, "bad argument #4 to 'trackAd' (string expected, got no value)")
    execFunction("trackAd", sdkName, placement, type, action)
end

function M.trackProgress(state, ...)
    execFunction("trackProgress", state, ...)
end

-- private
function execFunction(func, ...)
    for _, analytics in pairs(analyticsList) do
        local module = analytics["module"]

        if module then
            module[func](...)
        end
    end
end

function checkInterface(analyticsModule)
    for _, functionId in pairs(interface) do
        if type(analyticsModule["module"][functionId]) ~= "function" then
            error("function '" .. functionId .. "' is not implemented")
        end
    end
end

return M
