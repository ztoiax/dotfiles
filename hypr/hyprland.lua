-- ==================== 变量定义 ====================
local terminal = "ghostty"
local fileManager = "dolphin"
local fileManagerTui = "yazi"
local editor = "~/.mybin/neovide.sh"
local browser = "google-chrome-stable"

-- ==================== 显示器 ====================
-- monitor=,2880x1800@60,auto,auto
hl.monitor({ output = "", mode = "2880x1800@60", position = "auto", scale = "auto" })

-- ==================== 通用外观 ====================
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,
	   -- 边框颜色
	   col = {
	     active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
	     inactive_border = "rgba(595959aa)",
	   },
	   -- 允许通过点击和拖动边框/间隙来调整窗口大小
	   resize_on_border = true,

		layout = "scrolling", -- 滚动窗口
	},
  cursor = {
    no_hardware_cursors = 0,
    use_cpu_buffer = true,
    enable_hyprcursor = true,
  },
	dwindle = {
		mfact = 0.5,
		pseudotile = true,
		preserve_split = true,
	},
	master = {
		new_on_top = true,
		new_status = "master",
	},
  -- ==================== 滚动布局设置 ====================
	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.8,
		direction = "right",
		follow_focus = true,
	},
	decoration = {
		rounding = 12,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 30,
			render_power = 5,
			offset = "0 5",
			color = "rgba(00000070)",
		},
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696
    },
	},
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		new_window_takes_over_fullscreen = true,
		exit_window_retains_fullscreen = true,
		focus_on_activate = true,
	},
	xwayland = {
		enabled = false,
		force_zero_scaling = false,
		use_private_icon = true,
	},
	render = {
		expand_undersized_textures = true,
		direct_scanout = true,
	},
	animations = {
		enabled = true,
		first_launch_animation = true,
		bezier = {
			{ "wind", 0.05, 0.9, 0.1, 1.05 },
			{ "winIn", 0.1, 1.1, 0.1, 1.1 },
			{ "winOut", 0.3, -0.3, 0, 1 },
			{ "liner", 1, 1, 1, 1 },
		},
		animation = {
			{ "windows", 1, 6, "wind", "slide" },
			{ "windowsIn", 1, 6, "winIn", "slide" },
			{ "windowsOut", 1, 5, "winOut", "slide" },
			{ "windowsMove", 1, 5, "wind", "slide" },
			{ "border", 1, 1, "liner" },
			{ "borderangle", 1, 30, "liner", "loop" },
			{ "fade", 1, 10, "default" },
			{ "workspaces", 1, 5, "wind" },
		},
	},
})

-- ==================== 输入 ====================
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			tap_to_click = true,
			natural_scroll = false,
		},
	},
	gestures = {
		-- workspace_swipe = true,
		-- workspace_swipe_fingers = 3,
		-- workspace_swipe_distance = 200,
		-- workspace_swipe_duration = 200,
		-- workspace_swipe_invert = true,
		-- workspace_swipe_inertie = true,
	},
	debug = {
		damage_blink = false,
		overlay = false,
		colored_stdout_logs = true,
		enable_stdout_logs = true,
		suppress_errors = true,
		error_position = 0,
	},
})

-- 设备配置
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- ==================== 插件 ====================
hl.config({
	plugin = {
		["dynamic-cursors"] = {
			enabled = false,
			mode = "tilt",
			threshold = 2,
			shake = {
				enabled = true,
				nearest = true,
				threshold = 5.0,
				base = 4.0,
				speed = 4.0,
				influence = 0.0,
				limit = 0.0,
				timeout = 2000,
				effects = false,
				ipc = false,
			},
		},
		hyprfocus = {
			enabled = false,
			animate_floating = true,
			animate_workspacechange = true,
			focus_animation = "shrink",
			bezier = {
				{ "bezIn", 0.5, 0.0, 1.0, 0.5 },
				{ "bezOut", 0.0, 0.5, 0.5, 1.0 },
				{ "overshot", 0.05, 0.9, 0.1, 1.05 },
				{ "smoothOut", 0.36, 0, 0.66, -0.56 },
				{ "smoothIn", 0.25, 1, 0.5, 1 },
				{ "realsmooth", 0.28, 0.29, 0.69, 1.08 },
			},
			flash = {
				flash_opacity = 0.95,
				in_bezier = "realsmooth",
				in_speed = 0.5,
				out_bezier = "realsmooth",
				out_speed = 3,
			},
			shrink = {
				shrink_percentage = 0.95,
				in_bezier = "realsmooth",
				in_speed = 1,
				out_bezier = "realsmooth",
				out_speed = 2,
			},
		},
	},
})

-- ==================== 环境变量 ====================
hl.env("PATH", os.getenv("PATH") .. ":$scrPath")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
hl.env("GDK_DPI_SCALE", "1.25")
hl.env("QT_SCALE_FACTOR", "1.25")
hl.env("ecosystem", "no_update_news")

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")

-- ==================== 启动时执行 ====================
hl.on("hyprland.start", function()
	-- 环境变量同步
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd(
		"systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland && systemctl --user start xdg-desktop-portal xdg-desktop-portal-hyprland"
	)

	-- 顶部栏
	hl.exec_cmd("dms run")

	-- 插件与光标
	hl.exec_cmd("hyprpm reload")
	-- hl.exec_cmd("hyprctl setcursor rose-pine-hyprcursor 24")

	-- 窗口切换器
	hl.exec_cmd("hyprswitch init --show-title")

	-- 身份验证
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

	-- 可移动媒体管理
	hl.exec_cmd("udiskie --no-automount --smart-tray")

	-- 其他工具
	hl.exec_cmd("pot")
	hl.exec_cmd("fcitx5")
	hl.exec_cmd('keynav "loadconfig ~/.config/keynav/keynavrc"')

	-- 音乐播放器（工作区 9）
	hl.exec_cmd("[workspace 9 silent; fullscreen] /opt/SPlayer/SPlayer")
	hl.exec_cmd("[workspace 9 silent; fullscreen] localsend")

	-- 文件管理器与终端（工作区 3）
	hl.exec_cmd("[workspace 3 silent; fullscreen] " .. terminal .. " -e " .. fileManagerTui)
	hl.exec_cmd("[workspace 3 silent; fullscreen] " .. terminal)

	-- Neovide（工作区 2）
	hl.exec_cmd("[workspace 2 silent; fullscreen] neovide -- --listen /tmp/nvim.socket")

	-- 浏览器（工作区 1）
	hl.exec_cmd("[workspace 1 silent; fullscreen] " .. browser)

	-- 下载器
	-- hl.exec_cmd("surge server")

	-- 最后切换到工作区 1
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)

-- Smart gaps (ignoring special workspaces)
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })


-- ==================== 模块加载 ====================
-- 使用 require 加载其他配置文件，对应原 conf 中的 source 指令
require("keybind") -- ~/.config/hypr/keybind.lua
require("windowrules") -- ~/.config/hypr/windowrules.lua
-- require("nvidia")     -- ~/.config/hypr/nvidia.lua
require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
-- require("dms.binds")
require("dms.binds-user")
require("dms.windowrules")
