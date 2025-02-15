---@author Gage Henderson 2025-02-13 23:46
--
-- We use `SendInput` to simulate keyboard input.
-- https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput
--

local INPUT_KEYBOARD  = 1
local KEYEVENTF_KEYUP = 0x0002
local KILL_SWITCH     = "delete"

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
        uint32_t _padding; // Alignment fix for sizing.
        union {
            KEYBDINPUT ki;
        } DUMMYUNIONNAME;
    } INPUT;

    int SendInput(uint32_t cInputs, INPUT* pInputs, int cbSize);
    uint32_t MapVirtualKeyA(uint32_t uCode, uint32_t uMapType);
    short GetAsyncKeyState(int vKey);
    int GetLastError(void);
]]

---@class InputSimulator
---@field current_inputs {}
local InputSimulator = {}

function InputSimulator:new()
    local new = {
        current_inputs = {}
    }
    setmetatable(new, {__index = InputSimulator})

    EventManager:subscribe("chat_message", function(msg)
        -- zzz...
    end)

    return new
end

function InputSimulator:hold(key)
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
end

function InputSimulator:update(dt)
    -- Listen for kill switch!
    if bit.band(ffi.C.GetAsyncKeyState(keymap[KILL_SWITCH]), 0x8000) ~= 0 then
        love.event.quit()
    end
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
return InputSimulator
