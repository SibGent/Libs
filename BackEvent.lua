module("BackEvent", package.seeall)

local composer = require "composer"

local platform = system.getInfo("platform")
local stack = {}
local isLocked = false

local init
, isValueExists
, unlockBackEvent
, openPrevScene
, requestExit
, onKeyEvent


function BackEvent.back(options)
    if isLocked then
        return
    end

    if #stack > 1 then
        openPrevScene(options)
    else
        native.showAlert( "Hey Listen!", "Do you really want to exit?", { "Yes", "No" }, requestExit )
    end
end

function BackEvent.add(sceneName)
    stack[#stack + 1] = { [1]=sceneName }
end

function init()
    for name, super in pairs(composer) do
        if name == "gotoScene" then
            composer[name] = function(...)
                super(...)

                local sceneName = ...
                local stack_id

                for i = 1, #stack do
                    if isValueExists(stack[i], sceneName) then
                        stack_id = i
                        break
                    end
                end

                if not stack_id then
                    table.insert(stack, {...})
                end
            end
        end

        if name == "removeScene" then
            composer[name] = function(...)
                super(...)

                local sceneName = ...
                local stack_id

                for i = 1, #stack do
                    if isValueExists(stack[i], sceneName) then
                        stack_id = i
                        break
                    end
                end

                if stack_id then
                    table.remove(stack, stack_id)
                end
            end
        end
    end

    if platform == "android" then
        Runtime:addEventListener("key", onKeyEvent)
    end
end

function isValueExists(t, value)
    local isExists = false

    for _, v in pairs(t) do
        if v == value then
            isExists = true
            break
        end
    end

    return isExists
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

    local sceneName = stack[#stack][1]
    composer.gotoScene(sceneName, options)
end

function requestExit(event)
    if event.action == "clicked" then
        if event.index == 1 then
            native.requestExit()
        elseif event.index == 2 then

        end
    end
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
