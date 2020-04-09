local M = {}

local json = require "json"

local data
local directory

local getLocale
, getLanguageData
, getFilename
, isFileExists


function M.init(options)
	assert(options.directory, "option 'directory' is required")
	directory = options.directory

	local lang = getLocale(options.locale)
	data = getLanguageData(lang)

	if not data then
		error( "Localization file is corrupted" )
	end
end

function M.get(key)
	return data[key] or ( "<" .. key .. ">" )
end

function getLocale(lang)
	local lang = lang or system.getPreference("ui", "language")
	local filename = getFilename(lang)

	if not isFileExists(filename) then
		lang = "en"
	end

	return lang
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

	local fh = io.open(pathForFile, "r")
	if fh then
		isExists = true
		io.close(fh)
	end

	return isExists
end

return M
