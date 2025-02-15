---@author Gage Henderson 2025-02-13 23:46

local EventManager = require("modules.EventManager.EventManager")

---@class InputSimulator
local InputSimulator = {}

function InputSimulator:new()
    local new = {}
    setmetatable(new, {__index = InputSimulator})

    EventManager:subscribe("chat_message", function(msg)
    end)

    return new
end

return InputSimulator
