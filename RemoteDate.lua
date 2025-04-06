local M = {}

local REMOTE_SERVER = "https://google.com"
local PATTERN_GMT = "%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) GMT"
local MONTH_LIST = { Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12 }

local requestId

function M.getTime(onGetTime)
    assert(onGetTime, "argument 'onGetTime' is required as function")

    local params = {}
    params.timeout = 3

    requestId = network.request(REMOTE_SERVER, "HEAD", function(event)

        if not event.isError  then
            if event.phase == "ended" and event.status == 200 then
                local responseHeaders = event.responseHeaders
                local responseDate = responseHeaders.Date

                if type(responseHeaders) == "table" and responseDate then
                    local DateGMT = responseHeaders.Date
                    local day, month, year, hour, min, sec = DateGMT:match(PATTERN_GMT)
                    local dt = os.time() - os.time(os.date("!*t"))
                    local unixtime = os.time({
                        day = day,
                        month = MONTH_LIST[month],
                        year = year,
                        hour = hour,
                        min = min,
                        sec = sec
                    }) + dt

                    onGetTime({isError=false, unixtime=unixtime})
                else
                    onGetTime({isError=true})
                end
            else
                onGetTime({isError=true})
            end
        else
            onGetTime({isError=true})
        end

    end, params)
end

function M.stop()
    if requestId then
        network.cancel(requestId)
        requestId = nil
    end
end

return M
