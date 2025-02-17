---@author Gage Henderson 2025-02-13 23:46
--
-- We use `SendInput` to simulate keyboard input.
-- https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput
--

local INPUT_KEYBOARD  = 1
local KEYEVENTF_KEYUP = 0x0002
local KILL_SWITCH     = "delete"

local config       = require("config")
local ffi          = require("ffi")
local EventManager = require("modules.EventManager.EventManager")
local keymap       = require("modules.InputSimulator.keymap")

ffi.cdef[[
    typedef struct {
        uint16_t wVk;
        uint16_t wScan;
        uint32_t dwFlags;
        uint32_t time;
        uintptr_t dwExtraInfo;
    } KEYBDINPUT;

    typedef struct {
        uint32_t type;
        uint32_t _padding;
        union {
            KEYBDINPUT ki;
        } DUMMYUNIONNAME;
    } INPUT;

    int SendInput(uint32_t cInputs, INPUT* pInputs, int cbSize);
    uint32_t MapVirtualKeyA(uint32_t uCode, uint32_t uMapType);
    short GetAsyncKeyState(int vKey);
    int GetLastError(void);
]]

---@see TwitchChat
--
-- Handles the logic for actually simulating keyboard input - Does so based on
-- incoming chat messages via the `chat_message` event.
-- See: modules/TwitchChat for where these messages are broadcast from.
--
-- All keypresses are held down for a set duration - We track each currently
-- held key and send a release input when it's duration has expired.
-- To hold a key "indefinitely" just give it a very long duration.
--
-- Game commands are defined in `/game_configs/<game>.lua`. You can create
-- multiple configs here and change which one we use in your config.lua via the
-- `game_config` key.
--
---@class InputSimulator
---@field current_inputs table<string, number>
---@field game_commands table<string, {key: string, duration?: number, release?: boolean}>
local InputSimulator = {}

function InputSimulator:new()
    -- Make sure we have defined a game config in our config file.
    assert(config.game_config, "No game config defined in config file.")
    assert(type(config.game_config) == "string", "Game config must be a string. Example: \"trackmania\".")
    assert(type(config.game_config) == "string" and not string.find(config.game_config, ".lua"), "Remove the .lua extension from your game_config value in config.lua.")

    local new = {
        current_inputs = {},
        game_commands = require("game_configs." .. config.game_config)
    }
    setmetatable(new, {__index = InputSimulator})

    new:_validate_game_config()

    EventManager:subscribe("chat_message", function(msg)
        new:_handle_chat_messages(msg)
    end)

    return new
end

---@param msg string
function InputSimulator:_handle_chat_messages(msg)
    local trimmed = string.gsub(msg, "%s+", "")

    if self.game_commands[trimmed] then
        local command = self.game_commands[trimmed]

        if command.release then
            self:_release(command.key)
        elseif command.duration then
            self:_hold(command.key, command.duration)
        end
    end
end

function InputSimulator:update(dt)
    -- Listen for kill switch!
    if bit.band(ffi.C.GetAsyncKeyState(keymap[KILL_SWITCH]), 0x8000) ~= 0 then
        love.event.quit()
    end

    -- Run down durations, releasing keys if they have expired.
    for key, duration in pairs(self.current_inputs) do
        self.current_inputs[key] = duration - dt
        if duration <= 0 then
            self:_release(key)
        end
    end

    -- Broadcast our current inputs, listened to by Interface.
    EventManager:broadcast("update_input_state", self.current_inputs)
end

-- Get a new input struct to be used with `SendInput`.
---@param vk number Virtual Key Code
---@param isKeyUp boolean
---@return {type: number, ki: {wVk: number, wScan: number, dwFlags: number, time: number, dwExtraInfo: nil}}
function InputSimulator:_create_input(vk, isKeyUp)
    return ffi.new("INPUT", {
        type = INPUT_KEYBOARD,
        DUMMYUNIONNAME = {
            ki = {
                wVk = vk,
                wScan = ffi.C.MapVirtualKeyA(vk, 0),
                dwFlags = isKeyUp and KEYEVENTF_KEYUP or 0,
                time = 0,
                dwExtraInfo = 0
            }
        }
    })
end

---@param key string
---@param duration number
function InputSimulator:_hold(key, duration)
    local vk = keymap[key]

    local input = self:_create_input(vk, false)
    local inputArray = ffi.new("INPUT[1]", { input })
    local input_size = ffi.abi("64bit") and 40 or 28

    local result = ffi.C.SendInput(1, inputArray, input_size)

    if result == 0 then
        local errorCode = ffi.C.GetLastError()
        error(
            "Failed to simulate key hold for key: " .. tostring(key) ..
            ". Error code: " .. tostring(errorCode)
        )
    end

    self.current_inputs[key] = duration
end


---@param key string
function InputSimulator:_release(key)
    local vk = keymap[key]

    local input = self:_create_input(vk, true)
    local inputArray = ffi.new("INPUT[1]", { input })
    local input_size = ffi.abi("64bit") and 40 or 28

    local result = ffi.C.SendInput(1, inputArray, input_size)

    if result == 0 then
        local errorCode = ffi.C.GetLastError()
        error(
            "Failed to simulate key release for key: " .. tostring(key) ..
            ". Error code: " .. tostring(errorCode)
        )
    end

    self.current_inputs[key] = nil
end

-- Validate a game config, we run this in :new()
function InputSimulator:_validate_game_config()
    for command_string, data in pairs(self.game_commands) do
        assert(data.key, "No key defined for command: " .. command_string)
        assert(type(data.key) == "string", "Key must be a string. Example: \"up_arrow\" for command: " .. command_string)
        assert(keymap[data.key], "Could not find keymap for key: " .. data.key .. " for command: " .. command_string)
        assert(data.duration or data.release, "Must define either a duration or a release for command: " .. command_string)
        assert((data.duration and type(data.duration) == "number") or data.duration == nil, "Duration must be a number for command: " .. command_string)
    end
end

return InputSimulator
