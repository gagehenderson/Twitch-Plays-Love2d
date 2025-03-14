---@author Gage Henderson 2025-02-08 13:38

local EventManager = require("modules.EventManager.EventManager")
local MessageBox   = require("modules.Interface.Components.MessageBox")
local InputDisplay = require("modules.Interface.Components.InputDisplay")

--
-- Singleton class, instantiated and handled by `App`.
-- Handles creating, updating, drawing, and input for the UI.
--
---@class Interface
---@field logs_message_box MessageBox
---@field input_display InputDisplay
local Interface = {}

function Interface:new()
    local new = {}
    setmetatable(new, {__index = Interface})

    new.logs_message_box = MessageBox:new(0,0,0.5,1)
    new.input_display    = InputDisplay:new(0.5,0,0.5,1)

    EventManager:subscribe("log_message", function(...)
        new.logs_message_box:new_message(...)
    end)

    return new
end
function Interface:update(dt)
    self.logs_message_box:update(dt)
end
function Interface:draw()
    self.logs_message_box:draw()
    self.input_display:draw()
end
function Interface:resize(w,h)
    self.logs_message_box:resize(w,h)
    self.input_display:resize(w,h)
end
function Interface:keypressed(key)
end
function Interface:textinput(text)
end
function Interface:mousepressed(x,y,button)
    self.logs_message_box:mousepressed(x,y,button)
end
function Interface:mousereleased(x,y,button)
    self.logs_message_box:mousereleased(x,y,button)
end
function Interface:wheelmoved(x,y)
    self.logs_message_box:wheelmoved(x,y)
end

return Interface
