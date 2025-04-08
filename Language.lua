local M = {}

local json = require("json")

local data
local directory
local localizations
local languageId
local languageIndex

local getLocale
, getLocaleIndex
, getLanguageData
, getFilename
, isFileExists


function M.init(options)
    assert(options.directory, "option 'directory' is required")
    directory = options.directory
    localizations = options.localizations

    languageId = getLocale(options.locale)
    languageIndex = getLocaleIndex()
    data = getLanguageData(languageId)

    if not data then
        error( "Localization file is corrupted" )
    end
end

function M.next()
    languageIndex = languageIndex % #localizations + 1
    languageId = localizations[languageIndex]

    data = getLanguageData(languageId)
end

function M.getLanguageId()
    return languageId
end

function M.setLanguageId(locale)
    languageId = locale
    data = getLanguageData(languageId)
end

function M.get(key)
    return data[key] or ( "<" .. key .. ">" )
end

function getLocale(lang)
    local lang = lang or system.getPreference( "locale", "language" )
    local filename = getFilename(lang)

    if not isFileExists(filename) then
        lang = "en"
    end

    return lang
end

function getLocaleIndex()
    local index = 1

    for i = 1, #localizations do
        if languageId == localizations[i] then
            index = i
            break
        end
    end

    return index
end

function getLanguageData(lang)
    return json.decodeFile(system.pathForFile(getFilename(lang)))
end

function getFilename(lang)
    lang = lang:match("(%w+)-?") or ""
    return (directory .. lang .. ".json")
end

function isFileExists(filename, baseDir)
    local pathForFile = system.pathForFile(filename, baseDir)
    local isExists = false

    if not pathForFile then
        return isExists
    end

    local fh = io.open(pathForFile, "r")
    if fh then
        isExists = true
        io.close(fh)
    end

    return isExists
end

return M
