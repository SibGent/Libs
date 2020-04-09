local M = {}


local analyticsList = {}

local interface = {
    "selectContent",
    "setProgress",
    "addResource",
    "subResource",
    "purchaseItem"
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


function M.setProgress(state, ...)
    assert(state, "bad argument #1 to 'setProgress' (string expected, got no value)")
    execFunction("setProgress", state, ...)
end


function M.addResource(currency, amount, item_type, item_id)
    assert(currency, "bad argument #1 to 'addResource' (string expected, got no value)")
    assert(amount, "bad argument #2 to 'addResource' (number expected, got no value)")
    assert(item_type, "bad argument #3 to 'addResource' (string expected, got no value)")
    assert(item_id, "bad argument #4 to 'addResource' (string expected, got no value)")
    execFunction("addResource", currency, amount, item_type, item_id)
end


function M.subResource(currency, amount, item_type, item_id)
    assert(currency, "bad argument #1 to 'subResource' (string expected, got no value)")
    assert(amount, "bad argument #2 to 'subResource' (number expected, got no value)")
    assert(item_type, "bad argument #3 to 'subResource' (string expected, got no value)")
    assert(item_id, "bad argument #4 to 'subResource' (string expected, got no value)")
    execFunction("subResource", currency, amount, item_type, item_id)
end


function M.purchaseItem(cart_type, item_type, item_id, amount, currency)
    assert(cart_type, "bad argument #1 to 'purchaseItem' (string expected, got no value)")
    assert(item_type, "bad argument #2 to 'purchaseItem' (string expected, got no value)")
    assert(item_id, "bad argument #3 to 'purchaseItem' (string expected, got no value)")
    assert(amount, "bad argument #4 to 'purchaseItem' (number expected, got no value)")
    assert(currency, "bad argument #5 to 'purchaseItem' (string expected, got no value)")
    execFunction("purchaseItem", cart_type, item_type, item_id, amount, currency)
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
