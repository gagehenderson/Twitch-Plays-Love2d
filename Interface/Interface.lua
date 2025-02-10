---@author Gage Henderson 2025-02-08 13:38

local MessageBox = require("Interface.Components.MessageBox")

--
-- Non-global singleton class.
--
-- Handles creating, updating, drawing, and input for the interface.
--
---@class Interface
---@field logs_message_box MessageBox
local Interface = {
}
Interface.__index = Interface

function Interface:new()
    local new = {}
    setmetatable(new, Interface)

    new.logs_message_box = MessageBox:new(0,0,0.5,1)

    return new
end
function Interface:update(dt)
    self.logs_message_box:update(dt)
end
function Interface:draw()
    self.logs_message_box:draw()
end
function Interface:resize(w,h)
    self.logs_message_box:resize(w,h)
end
function Interface:keypressed(key)
end
function Interface:textinput(text)
end

return Interface
