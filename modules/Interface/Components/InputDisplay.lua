---@author Gage Henderson 2025-02-15 11:49

local BORDER_RADIUS = 5
local INNER_PADDING = 10 -- Space between actual bounds and visual border.
local MESSAGE_PADDING = 0 -- Space between visual border and text.
local MESSAGE_SPACING = 1 -- Space between messages.
local FONT = love.graphics.newFont(13)

local EventManager = require("modules.EventManager.EventManager")

---@see Interface for where this is instantiated and managed.
---@see InputSimulator for where we get our input state from.
--
-- UI Component that displays our current inputs and their remaining durations.
--
---@class InputDisplay
---@field position {x: number, y: number}
---@field dimensions {width: number, height: number}
---@field normal_pos {x: number, y: number}
---@field normal_dim {width: number, height: number}
---@field inputs table<string, number>
local InputDisplay = {}

-- Numbers should be between 0 - 1 representing a percentage of the screen.
---@param x number
---@param y number
---@param width number
---@param height number
function InputDisplay:new(x,y,width,height)
    local new = {
        position   = { x = 0, y = 0 },
        dimensions = { width = 0, height = 0 },
        normal_pos = { x = x, y = y },
        normal_dim = { width = width, height = height },
        inputs = {}
    }

    setmetatable(new, {__index = InputDisplay})

    new:resize()

    EventManager:subscribe("update_input_state", function(inputs)
        new.inputs = inputs
    end)

    return new
end

function InputDisplay:draw()
    local x      = self.position.x + INNER_PADDING
    local y      = self.position.y + INNER_PADDING
    local width  = self.dimensions.width - INNER_PADDING * 2
    local height = self.dimensions.height - INNER_PADDING * 2

    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, width, height, BORDER_RADIUS)

    x = x + MESSAGE_PADDING
    y = y + MESSAGE_PADDING

    love.graphics.setFont(FONT)
    love.graphics.setColor(1,1,1)

    local str = ""
    for key, duration in pairs(self.inputs) do
        str = str .. key .. " " .. duration
        love.graphics.printf(str, x, y, width - MESSAGE_PADDING * 2, "left")
    end

end

function InputDisplay:resize(w,h)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()

    self.position.x = self.normal_pos.x * w
    self.position.y = self.normal_pos.y * h
    self.dimensions.width  = self.normal_dim.width * w
    self.dimensions.height = self.normal_dim.height * h
end

return InputDisplay
