---@author Gage Henderson 2025-02-13 23:46

---@class InputSimulator
local InputSimulator = {}

function InputSimulator:new()
    local new = {}
    setmetatable(new, {__index = InputSimulator})

    return new
end

return InputSimulator
