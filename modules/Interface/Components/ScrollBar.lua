---@author Gage Henderson 2025-02-10 11:36

local BORDER_RADIUS = 5
local WIDTH = 20
local BG_COLOR = { 0.2, 0.2, 0.2 }
local THUMB_COLOR = { 0.5, 0.5, 0.5 }
local THUMB_HEIGHT = 50
local SCROLLWHEEL_INC = 10

--
-- Can be used to add a scroll bar to a UI element.
--
-- Can only scroll vertically.
--
-- Requires a fair amount of information from the parent (position/dimensions,
-- content height, max height).
--
---@class ScrollBar
---@field scroll_y number
---@field position {x: number, y: number}
---@field dimensions {width: number, height: number}
---@field content_bounds {x: number, y: number, width: number, height: number}
---@field thumb {y: number, height: number}
---@field content_height number
---@field scroll_direction "normal" | "inverse"
---@field is_dragging boolean True when the user has click and held on the thumb.
local ScrollBar = {}

---@param scroll_direction? "normal" | "inverse" Default: "normal"
function ScrollBar:new(scroll_direction)
    local new = {
        position   = { x = 0, y = 0 },
        dimensions = { width = WIDTH, height = 0 },
        thumb      = { y = 0, height = THUMB_HEIGHT },
        content_bounds   = { x = 0, y = 0, width = 0, height = 0},
        scroll_direction = scroll_direction or "normal",
        content_height   = 0,
        scroll_y         = 0,
        is_dragging      = false
    }
    setmetatable(new, {__index = ScrollBar})
    return new
end

---@param height number
function ScrollBar:set_content_height(height)
    self.content_height = height
end

---@param x number
---@param height number
function ScrollBar:set_content_bounds(x,y,width,height)
    self.content_bounds = {
        x = x, y = y,
        width = width, height = height
    }
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
    self:_handle_dragging()
    self:_update_idle_thumb()
end

function ScrollBar:draw()
    love.graphics.setColor(BG_COLOR)
    love.graphics.rectangle(
        "fill",
        self.position.x, self.position.y,
        self.dimensions.width, self.dimensions.height,
        BORDER_RADIUS
    )

    if self.content_height > self.content_bounds.height then
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

function ScrollBar:wheelmoved(_,y)
    self:_set_thumb_y(self.thumb.y - y * SCROLLWHEEL_INC)
end

-- Handle clicking and dragging the thumb.
function ScrollBar:_handle_dragging()
    if self.content_height > self.content_bounds.height and
    self.is_dragging then
        local mouse_y = love.mouse.getY()
        self:_set_thumb_y(mouse_y - self.thumb.height / 2)
    end
end

-- Updates the position of the thumb when the content is not scrollable, so
-- that when it becomes scrollable it is in the correct position.
function ScrollBar:_update_idle_thumb()
    if self.content_height <= self.content_bounds.height then
        if self.scroll_direction == "normal" then
            self.thumb.y = 0
        elseif self.scroll_direction == "inverse" then
            self.thumb.y = self.dimensions.height - self.thumb.height
        end
    end
end

-- Set the thumb y position
-- Clamps to bounds.
---@param y number
function ScrollBar:_set_thumb_y(y)
    local max_y = self.dimensions.height - self.thumb.height

    self.thumb.y = y

    -- Clamp
    if self.thumb.y < 0 then
        self.thumb.y = 0
    elseif self.thumb.y > max_y then
        self.thumb.y = max_y
    end

    -- Apply to scroll_y
    if self.scroll_direction == "normal" then
        self.scroll_y = (self.thumb.y / max_y) * (self.content_height - self.content_bounds.height)
    elseif self.scroll_direction == "inverse" then
        self.scroll_y = (1 - (self.thumb.y / max_y)) * (self.content_height - self.content_bounds.height)
    end
end

return ScrollBar
