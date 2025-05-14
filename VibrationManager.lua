local M = {}
local isVibrationEnabled = true


function M.setEnabled(enabled)
    isVibrationEnabled = enabled
end


function M.vibrate()
    if isVibrationEnabled then
        system.vibrate()
    end
end


function M.impactLight()
    if isVibrationEnabled then
        system.vibrate("impact", "light")
    end
end


function M.impactMedium()
    if isVibrationEnabled then
        system.vibrate("impact", "medium")
    end
end


function M.impactHeavy()
    if isVibrationEnabled then
        system.vibrate("impact", "heavy")
    end
end


function M.selection()
    if isVibrationEnabled then
        system.vibrate("selection")
    end
end


function M.notificationSuccess()
    if isVibrationEnabled then
        system.vibrate("notification", "success")
    end
end


function M.notificationWarning()
    if isVibrationEnabled then
        system.vibrate("notification", "warning")
    end
end


function M.notificationError()
    if isVibrationEnabled then
        system.vibrate("notification", "error")
    end
end


return M
