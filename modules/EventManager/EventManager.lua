---@author Gage Henderson 2025-02-10 08:35

local event_registry = require("modules.EventManager.event_registry")

-- 
-- A module that handles events.
--
-- To use a new event, you must register it in `EventManager/events_registry.lua`.
--
-- Events can be broadcast or subscribed to anywhere in the codebase.
-- For this project, I am using it to easily broadcast state changes across the
-- app.
--
---@class EventManager
---@field subscription_list table<string, table> Lists of subscribers for each event.
local EventManager = {
    subscription_list = {}
}

-- Subscribe to an event
---@param event_name string
---@param callback function
function EventManager:subscribe(event_name, callback)
    self:_check_event_exists(event_name)

    if not self.subscription_list[event_name] then
        self.subscription_list[event_name] = {}
    end

    table.insert(self.subscription_list[event_name], callback)
end

-- Broadcast an event to all subscribers of it.
-- Throws an error if the event has no subscribers.
-- Throws an error if the arguments don't match those defined in it's
-- event_registry entry.
---@param event_name string
---@param ... any
function EventManager:broadcast(event_name, ...)
    self:_check_event_exists(event_name)

    local subs = self.subscription_list[event_name]

    if not subs or #subs == 0 then
        error("You broadcasted the event \"" .. event_name .. "\" but it has no subscribers.", 3)
    end

    local expected_args = event_registry[event_name]
    local args = {...}
    for i=1, #expected_args do
        local valid_types = {}
        if type(expected_args[i]) == "string" then
            table.insert(valid_types, expected_args[i])
        end

        local is_valid = false
        for ia=1, #valid_types do
            if type(args[i]) == valid_types[ia] or valid_types[ia] == "any" then
                is_valid = true
            end
        end

        if not is_valid then
            error(
                "The event \"" .. event_name .. "\" received an invalid argument at index " .. i
                .. "\nExpected type: \"" .. expected_args[i] .. "\".\n"
                .. "Received type: \"" .. type(args[i]) .. "\"."
            , 3)
        end
    end

    if subs then
        for i = 1, #subs do
            subs[i](...)
        end
    end
end


function EventManager:_check_event_exists(event_name)
    if not event_registry[event_name] then
        error("Event \"" .. event_name .. "\" does not exist. Make sure you have registered your event in EventManager/event_registry.lua", 3)
    end
end
return EventManager
