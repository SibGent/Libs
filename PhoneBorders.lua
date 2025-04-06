local M = {}

local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()

function M.create(params)
    local params = params or {}
    local color = params.color or {0}

    local topBorder = display.newRect(
            display.screenOriginX,
            display.screenOriginY,
            display.actualContentWidth,
            topInset
    )
    topBorder.anchorX = 0
    topBorder.anchorY = 0
    topBorder.fill = color

    local bottomBorder = display.newRect(
            display.screenOriginX,
            display.screenOriginY + topInset + display.safeActualContentHeight,
            display.actualContentWidth,
            bottomInset
    )
    bottomBorder.anchorX = 0
    bottomBorder.anchorY = 0
    bottomBorder.fill = color

    return topBorder, bottomBorder
end

return M