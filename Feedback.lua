local M = {}

local platform = system.getInfo("platform")
local settings = {}

local feedbackRequest
, feedbackListener
, showNativePopup
, tryExecuteListener

function M.init(options)
    settings = options
end

function M.show()
    feedbackRequest()
end

function feedbackRequest()
    local translate = settings.translate

    local title = (translate) and translate(settings.title) or settings.title
    local message = (translate) and translate(settings.message) or settings.message
    local buttonAgree = (translate) and translate(settings.positive) or settings.positive
    local buttonCancel = (translate) and translate(settings.negative) or settings.negative

    native.showAlert(title, message, { buttonAgree, buttonCancel }, feedbackListener)
end

function feedbackListener(event)
    if event.action == "clicked" then
        local i = event.index

        if i == 1 then
            timer.performWithDelay(100, showNativePopup)
            tryExecuteListener(settings.onAgree)

        elseif i == 2 then
            tryExecuteListener(settings.onCancel)
        end
    end
end

function showNativePopup()
    native.showPopup("appStore", { iOSAppId = settings.appId[platform] })
end

function tryExecuteListener(listener)
    if type(listener) == "function" then
        listener()
    end
end

return M