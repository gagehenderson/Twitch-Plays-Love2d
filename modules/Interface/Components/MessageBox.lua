---@author Gage Henderson 2025-02-10 05:15

local BORDER_RADIUS = 5
local INNER_PADDING = 10 -- Space between actual bounds and visual border.
local MESSAGE_PADDING = 0 -- Space between visual border and text.
local MESSAGE_SPACING = 1 -- Space between messages.
local FONT = love.graphics.newFont(13)
local MAX_MESSAGES = 120

local ScrollBar = require("modules.Interface.Components.ScrollBar")

--
-- A UI element that displays a list of messages.
--
---@class MessageBox
---@field position {x: number, y: number}
---@field dimensions {width: number, height: number}
---@field normal_pos {x: number, y: number}
---@field normal_dim {width: number, height: number}
---@field messages string[] | table[]
---@field scroll_bar ScrollBar
local MessageBox = {}

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
        messages   = {},
        scroll_bar = ScrollBar:new("inverse")
    }
    setmetatable(new, {__index = MessageBox})

    new:resize()

    return new
end

-- Create a new message.
---@param ... string[]|table[] Can be a string or coloredText - See: https://love2d.org/wiki/love.graphics.print
function MessageBox:new_message(...)
    table.insert(self.messages, { ... })
    if #self.messages > MAX_MESSAGES then
        table.remove(self.messages, 1)
    end
end

function MessageBox:update(dt)
    self.scroll_bar:update(dt)
end

function MessageBox:draw()
    self:_draw_outline()
    self:_print_messages()
    self.scroll_bar:draw()
end

function MessageBox:resize(w,h)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()

    self.position.x = self.normal_pos.x * w
    self.position.y = self.normal_pos.y * h
    self.dimensions.width  = self.normal_dim.width * w
    self.dimensions.height = self.normal_dim.height * h

    self.scroll_bar:set_content_bounds(
        self.position.x + INNER_PADDING,
        self.position.y + INNER_PADDING,
        self.dimensions.width - INNER_PADDING * 2,
        self.dimensions.height - INNER_PADDING * 2
    )
    self.scroll_bar:set_visual_height(self.dimensions.height - INNER_PADDING * 2)
    self.scroll_bar:set_position(
        self.position.x + self.dimensions.width - INNER_PADDING - self.scroll_bar.dimensions.width,
        self.position.y + INNER_PADDING
    )
end

function MessageBox:mousepressed(x,y,button)
    self.scroll_bar:mousepressed(x,y,button)
end

function MessageBox:mousereleased(x,y,button)
    self.scroll_bar:mousereleased(x,y,button)
end

function MessageBox:wheelmoved(x,y)
    self.scroll_bar:wheelmoved(x,y)
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

-- Print out the messages.
-- Sets a scissor to the bounds of the message box so they don't overflow.
-- Accounts for our scroll position.
function MessageBox:_print_messages()
    local scissor_x      = self.position.x + INNER_PADDING
    local scissor_y      = self.position.y + INNER_PADDING
    local scissor_width  = self.dimensions.width - INNER_PADDING * 2
    local scissor_height = self.dimensions.height - INNER_PADDING * 2
    local limit = self.dimensions.width - INNER_PADDING * 2 - MESSAGE_PADDING
    local content_height = 0
    local x = self.position.x + INNER_PADDING + MESSAGE_PADDING

    local y = self.position.y + self.dimensions.height - INNER_PADDING * 2 - MESSAGE_PADDING
    y = y + self.scroll_bar.scroll_y

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(FONT)
    love.graphics.setScissor(scissor_x, scissor_y, scissor_width, scissor_height)

    for i=#self.messages, 1, -1 do
        local message = self.messages[i]
        local _, lines = FONT:getWrap(message, limit)
        local message_height = #lines * FONT:getHeight()

        y = y - message_height

        love.graphics.printf(
            message,
            math.floor(x), math.floor(y),
            limit, "left"
        )

        y = y - MESSAGE_SPACING
        content_height = content_height + message_height + MESSAGE_SPACING
    end

    love.graphics.setScissor()

    self.scroll_bar:set_content_height(content_height+FONT:getHeight())
end

return MessageBox
