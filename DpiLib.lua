local DpiLib = {}

local I_PHONE_PPI = {{163,163},{163},{326,326,326},{326},{326,326,326,326},{326,326},{401,326},{326,401,326,326},{326,401,326,401},{326,401,458,326,401,458}}
local IPOD_PPI = {{163},{163},{163},{326},{326},{326},{326}}
local IPAD_PPI = {{132},{132,132,132,132,163,163,163},{264,264,326,264,264,264},{264,264,264,326,326,326,326,326,326},{132,132,264,264},{264,264,264,264,264,264,264,264,264,264,264,264,264,264},{264,264,264,264, 264, 264}}

local getDpi
, getSimulatorDpi
, getIosDpi
, getAndroidDpi

function DpiLib:dp2px(dp)
	local dpi = getDpi()
	return dp*(dpi/160)
end

function DpiLib:px2dp(px)
	local dpi = getDpi()
	return px/(dpi/160)
end

function DpiLib:getDisplayInch()
	local dpi = getDpi()
	local displayHeightInInches, displayWidthInInches = display.pixelHeight/dpi, display.pixelWidth/dpi

	return displayWidthInInches, displayHeightInInches
end

function getDpi()
	local isSimulator = (system.getInfo("environment") == "simulator")
	local isIos = (system.getInfo("platform") == "ios")
	local isAndroid = (system.getInfo("platform") == "android")
	local dpi

	if isSimulator then
		dpi = getSimulatorDpi()
	elseif isIos then
		dpi = getIosDpi()
	elseif isAndroid then
		dpi = getAndroidDpi()
	else
		dpi = 160
	end

	return dpi
end

function getSimulatorDpi()
	local dpi = 300
	return dpi
end

function getIosDpi()
	local dpi = 163
	local architecture = system.getInfo( "architectureInfo" )
	local model = system.getInfo( "model" )

	local function wrapper()
		local m, n = string.match( architecture, model .. "(%d+),(%d+)" )
		m, n = tonumber(m), tonumber(n)

		if model == "iPhone" then
			dpi = I_PHONE_PPI[m][n]
		elseif model == "iPad" then
			dpi = IPAD_PPI[m][n]
		elseif model == "iPod" then
			dpi = IPOD_PPI[m][n]
		else
			dpi = 326
		end
	end

	pcall(wrapper)

	return dpi
end

function getAndroidDpi()
	local dpi = system.getInfo("androidDisplayApproximateDpi")
	return dpi
end

return DpiLib
