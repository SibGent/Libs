local NetLib = {}

local socket = require("socket")
local http = require("socket.http")

local HOST = "208.67.222.222"
local PORT = 53
local TIMEOUT = 1

local REMOTE_SERVER = "https://google.com"
local PATTERN_GMT = "%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) GMT"
local MONTH_LIST = { Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12 }

function NetLib.hasConnection()
    local hasConnection = true

    local tcp = assert(socket.tcp())
    tcp:settimeout(TIMEOUT, 't')

    local receive, errorMessage = tcp:connect(HOST, PORT)

    if not receive then
        hasConnection = false
    end

    tcp:close()
    tcp = nil

    return hasConnection
end

function NetLib.getRemoteDate()
    local body, code, headers = http.request({
        method = "HEAD",
        url = REMOTE_SERVER,
        create = function()
            local req_sock = socket.tcp()
            req_sock:settimeout(1, 'b')
            req_sock:settimeout(1, 't')
            return req_sock
        end
    })

    if headers and headers['date'] then
        local DateGMT = headers['date']
        local day, month, year, hour, min, sec = DateGMT:match(PATTERN_GMT)

        if not (day and month and year and hour and min and sec) then
            return nil
        end

        local dt = os.time() - os.time(os.date("!*t"))
        local unixtime = os.time({
            day = tonumber(day),
            month = MONTH_LIST[month],
            year = tonumber(year),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec)
        }) + dt

        return unixtime
    end

    return nil
end

return NetLib