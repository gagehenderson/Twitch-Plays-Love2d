---@author Gage Henderson 2025-02-10 11:36

local BORDER_RADIUS = 5
local WIDTH = 20
local BG_COLOR = { 0.2, 0.2, 0.2 }
local THUMB_COLOR = { 0.5, 0.5, 0.5 }
local THUMB_HEIGHT = 50
local SCROLLWHEEL_INC = 10

-- Can be used to add a scroll bar to a UI element.
-- Can only scroll vertically.
-- Requires a fair amount of information from the parent (position/dimensions,
-- content height, max height).
---@class ScrollBar
---@field scroll_y number
---@field position {x: number, y: number}
---@field dimensions {width: number, height: number}
---@field thumb {y: number, height: number}
---@field content_height number
---@field max_height number
---@field scroll_direction "normal" | "inverse"
---@field is_dragging boolean True when the user has click and held on the thumb.
local ScrollBar = {}
ScrollBar.__index = ScrollBar

---@param scroll_direction? "normal" | "inverse" Default: "normal"
function ScrollBar:new(scroll_direction)
    local new = {
        position   = { x = 0, y = 0 },
        dimensions = { width = WIDTH, height = 0 },
        thumb      = { y = 0, height = THUMB_HEIGHT },
        scroll_direction = scroll_direction or "normal",
        content_height   = 0,
        scroll_y         = 0,
        max_height       = 0,
        is_dragging      = false
    }
    setmetatable(new, ScrollBar)
    return new
end

---@param height number
function ScrollBar:set_content_height(height)
    self.content_height = height
end

---@param height number
function ScrollBar:set_max_height(height)
    self.max_height = height
end

---@param height number
function ScrollBar:set_visual_height(height)
    self.dimensions.height = height
end

---@param x? number
---@param y? number
function ScrollBar:set_position(x,y)
    self.position.x = x or self.position.x
    self.position.y = y or self.position.y
end

function ScrollBar:update(dt)
    self:_update_thumb()
end

function ScrollBar:draw()
    love.graphics.setColor(BG_COLOR)
    love.graphics.rectangle(
        "fill",
        self.position.x, self.position.y,
        self.dimensions.width, self.dimensions.height,
        BORDER_RADIUS
    )

    if self.content_height > self.max_height then
        love.graphics.setColor(THUMB_COLOR)
        love.graphics.rectangle(
            "fill",
            self.position.x, self.position.y + self.thumb.y,
            self.dimensions.width, self.thumb.height,
            BORDER_RADIUS
        )
    end
end

function ScrollBar:mousepressed(x,y,button)
    -- Clicking on the thumb.
    if button == 1 and x >= self.position.x and 
    x <= self.position.x + self.dimensions.width and
    y >= self.position.y + self.thumb.y and
    y <= self.position.y + self.thumb.y + self.thumb.height then
        self.is_dragging = true
    end
end

function ScrollBar:mousereleased(_,_,button)
    if button == 1 then
        self.is_dragging = false
    end
end

-- Handle the position of the thumb and the scroll_y.
-- Basically the actual scrolling behavior.
function ScrollBar:_update_thumb()
    if self.content_height <= self.max_height then
        if self.scroll_direction == "normal" then
            self.thumb.y = 0
        elseif self.scroll_direction == "inverse" then
            self.thumb.y = self.dimensions.height - self.thumb.height
        end
    else
        local max_y = self.dimensions.height - self.thumb.height
        local mouse_y = love.mouse.getY()

        if self.is_dragging then
            self.thumb.y = mouse_y - self.thumb.height / 2
            if self.thumb.y < 0 then
                self.thumb.y = 0
            elseif self.thumb.y > max_y then
                self.thumb.y = max_y
            end
        end

        if self.scroll_direction == "normal" then
            self.scroll_y = (self.thumb.y / max_y) * (self.content_height - self.max_height)
        elseif self.scroll_direction == "inverse" then
            self.scroll_y = (1 - (self.thumb.y / max_y)) * (self.content_height - self.max_height)
        end
    end
end

return ScrollBar
