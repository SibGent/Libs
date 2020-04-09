local M = {}

local DpiLib = require "Libs.DpiLib"

function M.fitImage(object, fitWidth, fitHeight, enlarge)
	local scale = fitHeight/object.height
	local newWidth = object.width*scale

	if newWidth > fitWidth then
		scale = fitWidth/object.width
	end

	if not enlarge and scale > 1 then
		return
	end

    object.width = object.width*scale
    object.height = object.height*scale
end

function M.getBannerHeight()
	local screen_height = DpiLib:px2dp(display.pixelHeight)
	local scale = display.actualContentHeight/display.pixelHeight
	local banner_height = 0

	if screen_height <= 400 then
		banner_height = 32
	elseif screen_height > 400 and screen_height <= 720 then
		banner_height = 50
	elseif screen_height > 720 then
		banner_height = 90
	end

	return DpiLib:dp2px(banner_height)*scale
end

function M.scaleObject(event, value)
	local object = event.target
	local value = value or 0.95

	if not object.isFocus then
		if event.phase == "began" or event.phase == "moved" then
			object.isFocus = true
			object.xScale = value
			object.yScale = value
			object.offsetX = (object.width - object.width*value)/2
			object.offsetY = (object.height - object.height*value)/2
			display.getCurrentStage():setFocus(object)
		end
	end

	if object.isFocus then
		if event.phase == "moved" then
				if event.x < object.contentBounds.xMin - object.offsetX or event.x > object.contentBounds.xMax + object.offsetX or
					event.y < object.contentBounds.yMin - object.offsetY or event.y > object.contentBounds.yMax + object.offsetY then
						object.isFocus = false
						object.xScale = 1
						object.yScale = 1
						display.getCurrentStage():setFocus(nil)
				end
		end

		if event.phase == "ended" then
			object.isFocus = false
			object.xScale = 1
			object.yScale = 1
			display.getCurrentStage():setFocus(nil)
		end
	end
end

return M
