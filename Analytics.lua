local M = {}

local analyticsList = {}

local interface = {
    "selectContent",
    "addCurrency",
    "subCurrency",
    "unlockAchievement",
    "postScore",
}

function M.init(params)
    params = params or {}
    params.isActive = (params.isActive == nil) and true or params.isActive

    if not params.isActive then
        return
    end

    for _, analytics in pairs(analyticsList) do
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

function M.unlockAchievement(achievement_id)
    assert(achievement_id, "bad argument #1 to 'unlockAchievement' (string expected, got no value)")
    execFunction("unlockAchievement", achievement_id)
end

function M.postScore(score, level, character)
    assert(score, "bad argument #1 to 'postScore' (string expected, got no value)")
    execFunction("postScore", achievement_id)
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
        if type(analyticsModule[functionId]) ~= "function" then
            error("function '" .. functionId .. "' is not implemented")
        end
    end
end

return M
