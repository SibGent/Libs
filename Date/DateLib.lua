local DateFormat = require("Libs.Date.DateFormat")

local M = {}

function M.getLocalizedData(timestamp, locale)
    local format = DateFormat[locale]
    if format == nil then
        format = DateFormat.en
        print("WARNING: locale .. " .. locale .. " is not set in Libs.Date.DateFormat module")
    end

    
    return os.date(format, timestamp)
end

return M