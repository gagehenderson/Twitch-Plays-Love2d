local HOLD   = 10000
local TINY   = 0.25
local SHORT  = 1
local MEDIUM = 2.5
local LONG   = 5

local GAS_KEY   = "i"
local RIGHT_KEY = "l"
local LEFT_KEY  = "j"
local BREAK_KEY = "space"

return {
    ["!holdgas"] = {
        key = GAS_KEY,
        duration = HOLD
    },
    ["!releasegas"] = {
        key = GAS_KEY,
        release = true
    },
    ["!tinygas"] = {
        key = GAS_KEY,
        duration = TINY
    },
    ["!shortgas"] = {
        key = GAS_KEY,
        duration = SHORT
    },
    ["!mediumgas"] = {
        key = GAS_KEY,
        duration = MEDIUM
    },
    ["!longgas"] = {
        key = GAS_KEY,
        duration = LONG
    },
    ["!holdbreak"] = {
        key = BREAK_KEY,
        duration = HOLD
    },
    ["!releasebreak"] = {
        key = BREAK_KEY,
        release = true
    },
    ["!tinybreak"] = {
        key = BREAK_KEY,
        duration = TINY
    },
    ["!shortbreak"] = {
        key = BREAK_KEY,
        duration = SHORT
    },
    ["!mediumbreak"] = {
        key = BREAK_KEY,
        duration = MEDIUM
    },
    ["!longbreak"] = {
        key = BREAK_KEY,
        duration = LONG
    },
    ["!holdright"] = {
        key = RIGHT_KEY,
        duration = HOLD
    },
    ["!releaseright"] = {
        key = RIGHT_KEY,
        release = true
    },
    ["!tinyright"] = {
        key = RIGHT_KEY,
        duration = TINY
    },
    ["!shortright"] = {
        key = RIGHT_KEY,
        duration = SHORT
    },
    ["!mediumright"] = {
        key = RIGHT_KEY,
        duration = MEDIUM
    },
    ["!longright"] = {
        key = RIGHT_KEY,
        duration = LONG
    },
    ["!holdleft"] = {
        key = LEFT_KEY,
        duration = HOLD
    },
    ["!releaseleft"] = {
        key = LEFT_KEY,
        release = true
    },
    ["!tinyleft"] = {
        key = LEFT_KEY,
        duration = TINY
    },
    ["!shortleft"] = {
        key = LEFT_KEY,
        duration = SHORT
    },
    ["!mediumleft"] = {
        key = LEFT_KEY,
        duration = MEDIUM
    },
    ["!longleft"] = {
        key = LEFT_KEY,
        duration = LONG
    }
}
