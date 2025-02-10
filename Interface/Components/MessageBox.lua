---@author Gage Henderson 2025-02-10 05:15

local BORDER_RADIUS = 5
local INNER_PADDING = 10 -- Space between actual bounds and visual border.

--
-- A UI element that displays a list of messages.
--
---@class MessageBox
---@field position {x: number, y: number}
---@field dimensions {width: number, height: number}
---@field normal_pos {x: number, y: number}
---@field normal_dim {width: number, height: number}
local MessageBox = {}
MessageBox.__index = MessageBox

-- Numbers should be between 0 - 1 representing a percentage of the screen.
---@param x number
---@param y number
---@param width number
---@param height number
function MessageBox:new(x,y,width,height)
    local new = {
        position   = { x = 0, y = 0 },
        dimensions = { width = 0, height = 0 },
        normal_pos = { x = x, y = y },
        normal_dim = { width = width, height = height },
        messages   = {}
    }
    setmetatable(new, MessageBox)

    new:resize()

    return new
end

function MessageBox:update(dt)
end

function MessageBox:draw()
    self:_draw_outline()
end

function MessageBox:resize(w,h)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()
    self.position.x = self.normal_pos.x * love.graphics.getWidth()
    self.position.y = self.normal_pos.y * love.graphics.getHeight()
    self.dimensions.width = self.normal_dim.width * love.graphics.getWidth()
    self.dimensions.height = self.normal_dim.height * love.graphics.getHeight()
end

function MessageBox:_draw_outline()
    local x      = self.position.x + INNER_PADDING
    local y      = self.position.y + INNER_PADDING
    local width  = self.dimensions.width - INNER_PADDING * 2
    local height = self.dimensions.height - INNER_PADDING * 2

    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, width, height, BORDER_RADIUS)
end

return MessageBox
