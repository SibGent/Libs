local M = {}

local platform = system.getInfo("platform")
local androidApiLevel = system.getInfo("androidApiLevel") or 0

function M.init()
    if platform == "android" and androidApiLevel > 28 then
        native.setProperty("androidSystemUiVisibility", "immersiveSticky")
    end
end

return M