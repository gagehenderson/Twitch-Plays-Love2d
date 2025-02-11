---@author Gage Henderson 2025-02-11 13:59

local socket = require("socket")
local config = require("config")
local EventManager = require("EventManager.EventManager")

-- Handles connecting to and communicating with the twitch chat irc!
---@class TwitchChat
---@field conn any Our connection to the IRC.
---@field is_connected boolean
---@field is_authenticated boolean
---@field is_joined boolean
local TwitchChat = {}

function TwitchChat:new()
    local new = {
        conn             = nil,
        is_connected     = false,
        is_authenticated = false,
        is_joined        = false
    }
    setmetatable(new, {__index = TwitchChat})
    return new
end

function TwitchChat:connect()
    -- Connect to the twitch chat irc.
    self.conn = assert(socket.connect("irc.chat.twitch.tv", 6667), "Failed to connect to Twitch IRC")
    self.conn:settimeout(0)
    EventManager:broadcast("log_message", "Successfully connected to Twitch IRC")

    -- Authenticate
    EventManager:broadcast("log_message", "Authenticating...")
    self.conn:send("PASS oauth:" .. config.oauth_token .. "\r\n")
    self.conn:send("NICK " .. config.username .. "\r\n")
end

-- Listen for incoming messages.
function TwitchChat:update()
    local line, err = self.conn:receive()
    if line then
        EventManager:broadcast("log_message", "[Received Message: ] " .. line)
    elseif err ~= "timeout" then
        EventManager:broadcast("log_message", {1,0,0}, "[ERROR MESSAGE: ] " .. err)
    end
end

return TwitchChat
