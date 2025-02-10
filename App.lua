---@author Gage Henderson 2025-02-08 12:47
local socket = require("socket")
local config = require("config")
local Interface = require("Interface.Interface")

-- Entry point for the app, a global module.
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
end
function App:textinput(text)
    self.interface:textinput(text)
end
