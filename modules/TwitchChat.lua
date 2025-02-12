---@author Gage Henderson 2025-02-11 13:59

local TWITCH_SERVER_PREFIX = ":tmi.twitch.tv"

local socket = require("socket")
local config = require("config")
local EventManager = require("modules.EventManager.EventManager")

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
    -- Make sure we have the required config values.
    assert(config.channel, "No channel specified in config file.")
    assert(config.username, "No username specified in config file.")
    assert(config.oauth_token, "No oauth token specified in config file.")

    -- Connect to the twitch chat irc.
    self.conn = assert(socket.connect("irc.chat.twitch.tv", 6667), "Failed to connect to Twitch IRC")
    self.conn:settimeout(0)
    EventManager:broadcast("log_message", {0,1,0}, "Successfully connected to Twitch IRC")
    self.is_connected = true

    -- Authenticate
    EventManager:broadcast("log_message", "Authenticating...")
    self.conn:send("PASS oauth:" .. config.oauth_token .. "\r\n")
    self.conn:send("NICK " .. config.username .. "\r\n")
end

-- Listen for incoming messages.
function TwitchChat:update()
    local line, err = self.conn:receive()
    if line then
        self:_handle_message(line)
    elseif err ~= "timeout" then
        EventManager:broadcast("log_message", {1,0,0}, "[ERROR MESSAGE: ] " .. err)
    end
end

function TwitchChat:disconnect()
    if self.conn then
        self.conn:send("PART " .. config.channel .. "\r\n")
        self.conn:close()
        EventManager:broadcast("log_message", "Disconnected from Twitch IRC")
    end
end

-- Here we handle all incoming messages.
-- Internally, this authenticates, confirms channel join, and responds to PINGS.
-- All incoming messsages are logged (via the log_message event).
-- Channel chat messages are broadcast (via the chat_message event).
---@param line string
function TwitchChat:_handle_message(line)
    if string.find(line, TWITCH_SERVER_PREFIX .. " 001") and not self.is_authenticated then
        self.is_authenticated = true
        EventManager:broadcast("log_message", {0,1,0}, "Successfully authenticated with Twitch IRC")

        self.conn:send("JOIN #" .. config.channel .. "\r\n")
        EventManager:broadcast("log_message", "Attemping to join channel: #" .. config.channel)
    elseif string.find(line, TWITCH_SERVER_PREFIX .. " 353") and not self.is_joined then
        self.is_joined = true
        EventManager:broadcast("log_message", {0,1,0}, "Successfully joined channel: #" .. config.channel)
    elseif string.match(line, "^PING :" .. TWITCH_SERVER_PREFIX) then
        self.conn:send("PONG :" .. TWITCH_SERVER_PREFIX .. "\r\n")
        EventManager:broadcast("log_message", {0.3,0.3,0.3}, "Sent PONG to Twitch")
    end
    EventManager:broadcast("log_message", {0.65,0.65,0.65}, "[Received Message: ] " .. line)

end

return TwitchChat
