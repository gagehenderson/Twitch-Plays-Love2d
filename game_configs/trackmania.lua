local HOLD = 10000
local TINY = 0.25
local SHORT = 1
local MEDIUM = 2.5
local LONG = 5

return {
    ["!holdgas"] = {
        key = "up_arrow",
        duration = HOLD
    },
    ["!releasegas"] = {
        key = "up_arrow",
        release = true
    },
    ["!tinygas"] = {
        key = "up_arrow",
        duration = TINY
    },
    ["!shortgas"] = {
        key = "up_arrow",
        duration = SHORT
    },
    ["!mediumgas"] = {
        key = "up_arrow",
        duration = MEDIUM
    },
    ["!longgas"] = {
        key = "up_arrow",
        duration = LONG
    },
    ["!holdbreak"] = {
        key = "down_arrow",
        duration = HOLD
    },
    ["!releasebreak"] = {
        key = "down_arrow",
        release = true
    },
    ["!tinybreak"] = {
        key = "down_arrow",
        duration = TINY
    },
    ["!shortbreak"] = {
        key = "down_arrow",
        duration = SHORT
    },
    ["!mediumbreak"] = {
        key = "down_arrow",
        duration = MEDIUM
    },
    ["!longbreak"] = {
        key = "down_arrow",
        duration = LONG
    },
    ["!holdright"] = {
        key = "right_arrow",
        duration = HOLD
    },
    ["!releaseright"] = {
        key = "right_arrow",
        release = true
    },
    ["!tinyright"] = {
        key = "right_arrow",
        duration = TINY
    },
    ["!shortright"] = {
        key = "right_arrow",
        duration = SHORT
    },
    ["!mediumright"] = {
        key = "right_arrow",
        duration = MEDIUM
    },
    ["!longright"] = {
        key = "right_arrow",
        duration = LONG
    },
    ["!holdleft"] = {
        key = "left_arrow",
        duration = HOLD
    },
    ["!releaseleft"] = {
        key = "left_arrow",
        release = true
    },
    ["!tinyleft"] = {
        key = "left_arrow",
        duration = TINY
    },
    ["!shortleft"] = {
        key = "left_arrow",
        duration = SHORT
    },
    ["!mediumleft"] = {
        key = "left_arrow",
        duration = MEDIUM
    },
    ["!longleft"] = {
        key = "left_arrow",
        duration = LONG
    }
}
