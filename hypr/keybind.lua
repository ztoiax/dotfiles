-- ~/.config/hypr/keybind.lua
-- Hyprland 0.55+ Lua 配置

local mainMod   = "SUPER"
local shiftMod  = "SUPER + SHIFT"
local altMod    = "SUPER + ALT"
local shift     = "SHIFT"
local CtrlAlt   = "CONTROL + ALT"

-- 切换窗口相关变量
local key             = "TAB"
local modifier        = "ALT"
local modifier_release = "ALT_L"
local reverse         = "SHIFT"

-- ==================== 基础操作 ====================
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(shiftMod .. " + Q", hl.dsp.exit())
hl.bind(mainMod .. " + W", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(shiftMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("~/.mybin/neovide.sh"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("ghostty -e yazi"))

-- 最小化窗口
hl.bind("SUPER + X", function ()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)

-- 启动器
-- hl.bind("ALT + space", hl.dsp.exec_cmd("rofi -matching normal -show run"))

-- 切换窗口（focuscurrentorlast）
hl.bind("SUPER + Tab", hl.dsp.focus({ last = true }))

-- 更改当前工作区的循环layout
hl.bind("SUPER+ SHIFT + tab", function ()
    local layouts   = { "scrolling", "dwindle", "master", "monocle" }
    local workspace = hl.get_active_workspace()
    if hl.get_active_special_workspace() then
        workspace = hl.get_active_special_workspace()
    end

    local next_layout = "dwindle"

    if not workspace then
        return
    end

    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end

    if workspace.special then
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
    else
        hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
    end
end)

-- ==================== 子映射：switch ====================
-- 按住 ALT，用 TAB 循环切换窗口
-- hl.bind("ALT + Tab", hl.dsp.submap("switch"))
--
-- hl.define_submap("switch", function()
--     hl.bind(modifier .. " + Tab", hl.dsp.exec_cmd("hyprswitch gui"), { repeating = true })
--     hl.bind(modifier .. " + " .. reverse .. " + Tab", hl.dsp.exec_cmd("hyprswitch gui -r"), { repeating = true })
--
--     -- 按数字键切换到指定偏移的窗口
--     for i = 1, 5 do
--         hl.bind(modifier .. " + " .. i, hl.dsp.exec_cmd("hyprswitch gui --offset=" .. i))
--         hl.bind(modifier .. " + " .. reverse .. " + " .. i, hl.dsp.exec_cmd("hyprswitch gui --offset=" .. i .. " -r"))
--     end
--
--     -- 松开 ALT 时退出子映射并关闭 hyprswitch
--     hl.bind(modifier_release, function()
--         hl.dispatch(hl.dsp.exec_cmd("hyprswitch close"))
--         hl.dispatch(hl.dsp.submap("reset"))
--     end, { release = true })
--
--     -- ESC 兜底
--     hl.bind("Escape", function()
--         hl.dispatch(hl.dsp.exec_cmd("hyprswitch close --kill"))
--         hl.dispatch(hl.dsp.submap("reset"))
--     end, { release = true })
-- end)

-- ==================== 移动焦点 ====================
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + Right", hl.dsp.group.next())
hl.bind(mainMod .. " + Left", hl.dsp.group.prev())
hl.bind(mainMod .. " + Up", hl.dsp.group.prev())
hl.bind(mainMod .. " + Down", hl.dsp.group.next())

-- Vim 风格
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.group.next())
hl.bind(mainMod .. " + K", hl.dsp.group.prev())
hl.bind(mainMod .. " + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + L", hl.dsp.group.next())

-- ==================== 切换工作区 ====================
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- 相对工作区移动窗口
hl.bind(shiftMod .. " + J", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(shiftMod .. " + K", hl.dsp.window.move({ workspace = "r-1" }))

-- ==================== 特殊工作区 ====================
hl.bind(mainMod .. " + z", hl.dsp.workspace.toggle_special())
hl.bind(shiftMod .. " + z", hl.dsp.exec_cmd("~/.config/hypr/script/移动当前窗口到特殊工作区.sh"))

-- ==================== 鼠标滚轮切换工作区 ====================
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- ==================== 鼠标拖拽窗口 ====================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize({ x = 0, y = 0, relative = true }))

-- ==================== 调整窗口大小 ====================
hl.bind(shiftMod .. " + Right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }),  { repeating = true })
hl.bind(shiftMod .. " + Left",  hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(shiftMod .. " + Up",    hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(shiftMod .. " + Down",  hl.dsp.window.resize({ x = 0, y = 30, relative = true }),  { repeating = true })

-- ==================== 壁纸切换 ====================
-- hl.bind(CtrlAlt .. " + N", hl.dsp.exec_cmd("wpaperctl next"))
-- hl.bind(CtrlAlt .. " + P", hl.dsp.exec_cmd("wpaperctl previous"))

-- ==================== 通知 ====================
-- hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- ==================== 大小写通知 ====================
-- hl.bind("CAPS", hl.dsp.exec_cmd("swayosd-client --caps-lock"), { release = true, locked = true })

-- ==================== dmenu / 脚本 ====================
hl.bind("ALT + O", hl.dsp.exec_cmd("~/.mybin/dmenu-search.py"), { locked = true, repeating = true })
hl.bind("ALT + SHIFT + O", hl.dsp.exec_cmd("~/.mybin/dmenu-search.py --category"), { locked = true, repeating = true })
hl.bind("ALT + U", hl.dsp.exec_cmd("~/.mybin/dmenu-url.py"), { locked = true, repeating = true })
hl.bind("ALT + H", hl.dsp.exec_cmd("~/.mybin/dmenu-cphistory.sh"), { locked = true, repeating = true })
hl.bind("ALT + L", hl.dsp.exec_cmd("~/.mybin/dmenu-cpline.sh"), { locked = true, repeating = true })
hl.bind("CTRL + Return", hl.dsp.exec_cmd("adb shell input keyevent 26"), { locked = true, repeating = true })

-- ==================== 截图 ====================
hl.bind(CtrlAlt .. " + A", hl.dsp.exec_cmd("hyprshot -m region -o ~/Downloads/"))
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Downloads/screen_shot_$(date +\"Y-m-d_H-M-S\").png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

-- ==================== 录屏 ====================
hl.bind("CONTROL + ALT + SHIFT + A", hl.dsp.exec_cmd("kooha"))

-- ==================== 触控板手势 ====================
-- 三指左右滑动切换工作区
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- SUPER + 三指上滑全屏
hl.gesture({ fingers = 3, direction = "up", scale = 1.5, action = "fullscreen" })
-- SUPER + 三指下滑浮动窗口
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, action = "float" })

-- 最小化 / 恢复窗口的逻辑（提取为函数）
local function toggle_minimize()
    if hl.get_workspace("special:minimized") then
        -- 恢复：把带 minimized tag 的窗口移回当前工作区，并清除 tag
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        -- 最小化：给当前窗口打 tag，并移到 special:minimized 工作区（不跟随）
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end

-- 三指捏合手势绑定（与快捷键共用同一函数）
hl.gesture({
    fingers = 3,
    direction = "pinch",
    action = toggle_minimize
})

-- SUPER + 四指任意方向调整大小
hl.gesture({ fingers = 4, direction = "swipe", scale = 1.0, action = "resize" })

