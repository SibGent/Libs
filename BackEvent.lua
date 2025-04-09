module("BackEvent", package.seeall)

local composer = require "composer"

local platform = system.getInfo("platform")
local stack = {}
local isLocked = false

local init
, unlockBackEvent
, openPrevScene
, onKeyEvent


function BackEvent.back(options)
    if isLocked then
        return
    end

    if #stack > 1 then
        openPrevScene(options)
    end
end

function BackEvent.add(sceneName)
    table.insert(stack, sceneName)
end

function init()
    local originalGotoScene = composer.gotoScene
    composer.gotoScene = function(sceneName, ...)
        originalGotoScene(sceneName, ...)
        BackEvent.add(sceneName)
    end

    local originalRemoveScene = composer.removeScene
    composer.removeScene = function(sceneName)
        for i = #stack, 1, -1 do
            if stack[i] == sceneName then
                table.remove(stack, i)
                break
            end
        end
        originalRemoveScene(sceneName)
    end

    if platform == "android" then
        Runtime:addEventListener("key", onKeyEvent)
    end
end

function unlockBackEvent()
    isLocked = false
end

function openPrevScene(options)
    options = options or {}

    if options.time then
        isLocked = true
        timer.performWithDelay(options.time, unlockBackEvent)
    end

    table.remove(stack, #stack)

    local prevSceneName = stack[#stack]
    composer.gotoScene(prevSceneName, options)
end

function onKeyEvent(event)
    if platform == "android" then
        if event.keyName == "back" then
            if event.phase == "down" then
                BackEvent.back()
            end
        end

        return true
    end

    return false
end

init()
