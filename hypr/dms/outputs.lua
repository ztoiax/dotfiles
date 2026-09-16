-- Migrated from existing hyprlang monitor lines

hl.monitor({ output = "", mode = "2880x1800@120", position = "auto", scale = "auto" })
hl.monitor({ output = "", mode = "2880x1800@60", position = "auto", scale = "auto" })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "4096x2160@60", position = "0x0", scale = 1 })

-- Default fallback
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
