local M = {}

local transitionLists = {}

local defineTransition
, runTransition
, onShake
, onZoomInOut

function M.stop(tag)
    transition.cancel(tag)
end

function M.shake(object, options)
    onShake(object, options)
end

function M.zoomInOut(object, options)
    onZoomInOut(object, options)
end

-- private
function defineTransition(object, transitionList)
    transitionLists[object] = {}
    transitionLists[object].list = transitionList
    transitionLists[object].index = 0
end

function runTransition(object)
    assert(transitionLists[object] ~= nil)
    local n = transitionLists[object].index + 1

    if n <= #transitionLists[object].list then
        transitionLists[object].index = n
        local tdef = transitionLists[object].list[n]
        tdef.onComplete = tdef.onComplete or runTransition
        transition.to(object,tdef)
    else
        transitionLists[object] = nil
    end
end

function onShake(object, options)

    defineTransition(object, {
        { tag="shake", time=options.time, rotation=object.rotation - options.rotation, transition=easing.continuousLoop },
        { tag="shake", time=options.time/2, rotation=object.rotation + options.rotation/2, transition=easing.continuousLoop, onComplete=function()

            if options.iterations > 0 then
                options.iterations = options.iterations - 1
                onShake(object, options)
            end

        end },
    })

    if options.iterations == 0 then
        if options.listener then
            options.listener()
        end

    elseif options.iterations > 0 then
        runTransition(object)
    end
end


function onZoomInOut(object, options)

    defineTransition(object, {
        { tag="zoomInOut", time=options.time, xScale=options.scaleIn, yScale=options.scaleIn },
        { tag="zoomInOut", time=options.time, xScale=options.scaleOut, yScale=options.scaleOut },
        { tag="zoomInOut", time=options.time, xScale=1, yScale=1, onComplete=function()

            if options.iterations ~= 0 then
                options.iterations = options.iterations - 1
                onZoomInOut(object, options)
            end

        end },
    })

    if options.iterations == 0 then
        if options.listener then
            options.listener()
        end

    elseif options.iterations > 0 then
        runTransition(object)
    end
end

return M
