local M = {}

local json = require("json")

local config
local onLoad
local onSave

local SAVE_DIR = system.pathForFile("save.json", system.DocumentsDirectory)
local SAVE = {}

local initConfig
, getKeysByLine
, executeListener

function M.init(options)
    config = options.config
    onLoad = options.onLoad
    onSave = options.onSave
end


function M.load()
    local file = io.open(SAVE_DIR, "r")

    if file then
        local content = file:read("*a")
        SAVE = json.decode(content)

        if not SAVE then
            SAVE = {}
            native.showAlert("Warning", "local save file is corrupted", { "OK" })
        end

        io.close(file)
    end

    executeListener(onLoad)
    initConfig()
end


function M.save()
    local file = io.open(SAVE_DIR, "w+")

    if file then
        local encoded = json.encode(SAVE, { indent = true })
        file:write(encoded)

        io.close(file)
    end

    executeListener(onSave)
end


function M.keyExists(line)
    local keys = getKeysByLine(line)
    local value

    for i = 1, #keys do
        local key = keys[i]

        if value ~= nil then
            value = value[key]
        else
            value = SAVE[key]
        end
    end

    return (value ~= nil) and true or false
end


function M.setValue(line, value)
    local keys = getKeysByLine(line)
    local link = nil

    for i = 1, #keys - 1 do
        local key = keys[i]

        if link then
            link[key] = link[key] or {}
            link = link[key]
        else
            SAVE[key] = SAVE[key] or {}
            link = SAVE[key]
        end
    end

    if link then
        link[keys[#keys]] = value
    else
        SAVE[keys[1]] = value
    end
end


function M.getValue(line)
    local keys = getKeysByLine(line)
    local value = SAVE[keys[1]]

    if not value then
        return value
    end

    for i = 2, #keys do
        local key = keys[i]
        value = value[key]

        if not value or type(value) ~= "table" then
            return value
        end
    end

    return value
end


function M.setDump(content, isJson)
    SAVE = (isJson) and json.decode(content) or content
end


function M.getDump(isJson)
    return (isJson) and json.encode(SAVE) or SAVE
end


function initConfig()
    for k, defaultValue in pairs(config) do
        if not M.keyExists(k) then
            M.setValue(k, defaultValue)
        elseif type(defaultValue) ~= type(M.getValue(k)) then
            M.setValue(k, defaultValue)
        end
    end
end


function getKeysByLine(line)
    local keys = {}

    for key in line:gmatch("[^%.]+") do
        keys[1 + #keys] = key
    end

    return keys
end


function executeListener(listener)
    if type(listener) == "function" then
        listener()
    end
end


return M
