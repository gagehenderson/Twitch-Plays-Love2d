---@author Gage Henderson 2025-02-08 12:47

local socket = require("socket")
local config = require("config")
local EventManager = require("EventManager.EventManager")
local Interface = require("Interface.Interface")

--
-- Entry point for the app, a global module.
--
---@class App
---@field interface Interface
App = {
}

function App:load()
    self.interface = Interface:new()
end
function App:update(dt)
    self.interface:update(dt)
end
function App:draw()
    self.interface:draw()
end
function App:resize(w,h)
    self.interface:resize(w,h)
end
function App:keypressed(key)
    self.interface:keypressed(key)

    -- TESTING! REMOVE ME!
    if key == "space" then
        for i=1,100 do
            EventManager:broadcast("log_message", tostring(i))
        end
    end
end
function App:textinput(text)
    self.interface:textinput(text)
end
function App:mousepressed(x,y,button)
    self.interface:mousepressed(x,y,button)
end
function App:mousereleased(x,y,button)
    self.interface:mousereleased(x,y,button)
end
function App:wheelmoved(x,y)
    self.interface:wheelmoved(x,y)
end
