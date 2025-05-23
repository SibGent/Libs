local M = {}

-- local plugins = {
--     android = "CoronaProvider.native.popup.social",
--     ios = "CoronaProvider.native.popup.activity",
-- }

local platform = system.getInfo("platform")

function M.share(params)

    local listener = params.listener
    local filename = params.filename
    local baseDir = params.baseDir
    local url = params.url
    local message = params.message

    if platform == "android" then

        native.showPopup("social",
        {
            message = message,
            image = { { filename=filename, baseDir=baseDir } },
            url = { url },
            listener = listener,
        })

    elseif platform == "ios" then

        local itemsToShare = {
            { type = "image", value = { filename=filename, baseDir=baseDir } },
            { type = "url", value = url },
            { type = "string", value = message },
        }

        local options = { items=itemsToShare, listener=listener }
        native.showPopup("activity", options)

    else
        print("WARNING: " .. platform .. "is not supported")
    end
end

return M