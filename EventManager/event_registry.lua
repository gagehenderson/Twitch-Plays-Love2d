---@author Gage Henderson 2025-02-10 08:45

---@see EventManager
--
-- A list of all events! You must define an event here before you can use it
-- in any capacity.
-- 
-- Each event should list out it's arguments by type - These will be checked each
-- time an event is broadcast.
-- 
-- You can use `any` to allow any type, or an array of types to allow multiple,
-- example: `"my_event" = {"string", "table", {"string", "number"}}`
---@type table<string, string[] | string[][]>
return {

    ---@see Interface
    -- Can just pass a string, or a series of arguments as coloredText.
    -- Colored text: https://love2d.org/wiki/love.graphics.print
    ["log_message"] = { "any" }
}
