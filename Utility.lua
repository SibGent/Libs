local M = {}

function M.fitObject(object, fitWidth, fitHeight, enlarge)
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

function M.scaleObject(event, value)
    local object = event.target
    value = value or 0.95

    if not object then
        return
    end

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
                if event.x < object.contentBounds.xMin - object.offsetX
                        or event.x > object.contentBounds.xMax + object.offsetX
                        or event.y < object.contentBounds.yMin - object.offsetY
                        or event.y > object.contentBounds.yMax + object.offsetY then
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

function M.getRandomItem(data)
    if type(data) ~= "table" then
        return nil
    end

    local total = 0
    local rndWeight = 0
    local currentWeight = 0

    for _, item in pairs(data) do
        total = total + item.weight
    end

    rndWeight = math.random(1, total)

    for _, item in pairs(data) do
        currentWeight = currentWeight + item.weight

        if (currentWeight >= rndWeight) then
            return item
        end
    end
end

function M.formatSeconds(seconds)
    local m = math.floor(seconds/60)%60
    local s = seconds%60

    return string.format("%02d", m) .. ":" .. string.format("%02d", s)
end

function M.printMemUsage()
    local memUsed = (collectgarbage("count")) / 1000
    local texUsed = system.getInfo( "textureMemoryUsed" ) / 1000000

    print("\n---------MEMORY USAGE INFORMATION---------")
    print("System Memory Used:", string.format("%.03f", memUsed), "Mb")
    print("Texture Memory Used:", string.format("%.03f", texUsed), "Mb")
    print("------------------------------------------\n")

    return true
end

return M
