-- DMS user keybind overrides (edit via Control Center or dms; do not remove this header)

-- 切换窗口
hl.bind("ALT + TAB", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
-- 壁纸选择
hl.bind("SUPER + Y", hl.dsp.exec_cmd("dms ipc call dash toggle wallpaper"))
-- 聚集搜索
hl.bind("ALT + space", hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"), { description = "dms ipc call spotlight-bar toggle" })
-- 剪切板
hl.bind("CTRL + Semicolon", hl.dsp.exec_cmd("dms ipc call clipboard toggle"), { description = "dms ipc call clipboard toggle" })
-- 锁屏
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("dms ipc call lock lock"), { description = "dms ipc call lock lock" })
-- dms菜单
hl.bind("ALT + SHIFT + space", hl.dsp.exec_cmd("dms ipc call powermenu toggle"), { description = "dms ipc call powermenu toggle" })
-- 任务管理器
hl.bind("SUPER + M", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
-- 通知
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))

-- === Audio Controls ===
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true })
hl.bind("ALT + N", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true, description = "dms ipc call audio decrement 3" })
hl.bind("ALT + M", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true, description = "dms ipc call audio increment 3" })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })

hl.bind("ALT + s", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("ALT + a", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })
hl.bind("ALT + d", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })


-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })

hl.bind("ALT + F3", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("ALT + F2", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })

-- === Cheat sheet
hl.bind("SUPER + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))

-- === System Controls ===
hl.bind("SUPER + SHIFT + P", hl.dsp.dpms({ action = "toggle" }))
