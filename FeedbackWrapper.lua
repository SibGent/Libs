local M = {}

local platformVersion = system.getInfo("platformVersion") or "0"
local iOSVersion = tonumber(platformVersion:sub(1, 4)) or 0
local platform = system.getInfo("platform")
local reviewPopUp
local isInit

local FEEDBACK_STORE
local FEEDBACK_TITLE
local FEEDBACK_MESSAGE
local FEEDBACK_POSITIVE
local FEEDBACK_NEGATIVE
local FEEDBACK_ON_AGREE
local FEEDBACK_ON_CANCEL

local setOptions
, showNativeReview
, onComplete
, executeListener


function M.init(options)
    setOptions(options)

    if platform == "ios" then
        reviewPopUp = require("plugin.reviewPopUp")
    elseif platform == "android" then

    end

    isInit = true
end


function M.show()
    if not isInit then
        error("FeedbackWrapper is not init")
    end

    if platform == "ios" then
        if iOSVersion >= 10.3 then
            reviewPopUp.show()
        else
            showNativeReview()
        end

    elseif platform == "android" then
        showNativeReview()
    end
end


-- private
function setOptions(options)
    local options = options or {}
	FEEDBACK_STORE = options.store[platform] or FEEDBACK_STORE
	FEEDBACK_TITLE = options.title or FEEDBACK_TITLE
	FEEDBACK_MESSAGE = options.message or FEEDBACK_MESSAGE
	FEEDBACK_POSITIVE = options.positive or FEEDBACK_POSITIVE
	FEEDBACK_NEGATIVE = options.negative or FEEDBACK_NEGATIVE
	FEEDBACK_ON_AGREE = options.onAgree
	FEEDBACK_ON_CANCEL = options.onCancel
end

function showNativeReview()
    native.showAlert(FEEDBACK_TITLE, FEEDBACK_MESSAGE, { FEEDBACK_POSITIVE, FEEDBACK_NEGATIVE }, onComplete)
end

function onComplete(event)
    if event.action == "clicked" then
        if event.index == 1 then -- agree
            if system.canOpenURL(FEEDBACK_STORE) then
                system.openURL(FEEDBACK_STORE)
            end

            executeListener(FEEDBACK_ON_AGREE)

        elseif event.index == 2 then -- cancel
            executeListener(FEEDBACK_ON_CANCEL)
        end
    end
end

function executeListener(listener)
	if listener then
		listener()
	end
end

return M
