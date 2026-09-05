-- This script enables a "hold to fast-play" feature in MPV (similar to YouTube). When the left mouse button (MBTN_LEFT) is held down for a specified duration, the playback speed increases to a user-defined fast speed. Releasing the button returns the speed to the previous speed.
--
-- Keybinding: "MBTN_LEFT" (left mouse button) triggers the fast-play feature. Change the last line to another key or mouse button (e.g., "f", "SPACE", "MBTN_RIGHT") if desired.
--
-- This script was inspired and based on https://github.com/Ciacconas/mpv-scripts/blob/master/hold_accelerate.lua

-- This source code is public domain, do whatever you want.

local mp = require("mp")

-- User Variables
local fast_speed = 3.0 -- Speed multiplier when holding the button (e.g., 2.0 = 2x speed). Adjust this to change how fast playback becomes.
local hold_threshold = 0.25 -- Time in seconds to hold the button before fast playback starts. Increase for a longer delay, decrease for quicker response.

-- Internal variables
local timer = nil
local is_held = false
local previous_speed = 1.0

-- local function set_fast_speed()
--     if is_held then
--         mp.set_property("speed", fast_speed)
--     end
-- end
local function set_fast_speed()
    if is_held then
        mp.set_property("speed", fast_speed)
        -- 在倍速生效时，让 uosc 闪烁一下速度指示器
        mp.command("script-binding uosc/flash-speed")
    end
end

local function fast_play(table)
    if table == nil then return end

    if table["event"] == "down" then
        is_held = true
        previous_speed = mp.get_property_number("speed")
        if timer then
            timer:kill()
        end
        timer = mp.add_timeout(hold_threshold, set_fast_speed)

    elseif table["event"] == "up" then
        is_held = false
        if timer then
            timer:kill()
            timer = nil
        end
        mp.set_property("speed", previous_speed)

        -- 在速度恢复时，同样闪烁一下
        mp.command("script-binding uosc/flash-speed")
    end
end

mp.add_forced_key_binding("MBTN_LEFT", "hold_fast", fast_play, { complex = true, repeatable = false })

