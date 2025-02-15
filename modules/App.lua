---@author Gage Henderson 2025-02-08 12:47

local Interface  = require("modules.Interface.Interface")
local TwitchChat = require("modules.TwitchChat")
local InputSimulator = require("modules.InputSimulator.InputSimulator")

--
-- Entry point for the app, a global module.
-- Initializes / updates submodules.
-- Most communication between submodules happens through events (See EventManager).
--
---@class App
---@field interface Interface
---@field twitch_chat TwitchChat
---@field input_simulator InputSimulator
App = {}

function App:load()
    -- Init submodules.
    self.interface = Interface:new()
    self.twitch_chat = TwitchChat:new()
    self.input_simulator = InputSimulator:new()

    self.twitch_chat:connect()
end
function App:update(dt)
    self.interface:update(dt)
    self.twitch_chat:update()
    self.input_simulator:update(dt)
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
function App:mousepressed(x,y,button)
    self.interface:mousepressed(x,y,button)
end
function App:mousereleased(x,y,button)
    self.interface:mousereleased(x,y,button)
end
function App:wheelmoved(x,y)
    self.interface:wheelmoved(x,y)
end
function App:quit()
    self.twitch_chat:disconnect()
end
