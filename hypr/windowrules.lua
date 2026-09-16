-- ~/.config/hypr/windowrules.lua
-- 由 windowrules.conf 转换并优化

-- ==================== 辅助函数 ====================

-- 批量注册透明度规则：给定透明度和一组 class 匹配模式
local function add_opacity(opacity, classes)
	for _, class in ipairs(classes) do
		hl.window_rule({
			match = { class = class },
			opacity = opacity,
		})
	end
end

-- 批量注册浮动规则
local function add_float(rules)
	for _, rule in ipairs(rules) do
		hl.window_rule({
			match = rule,
			float = true,
		})
	end
end

-- ==================== 透明度规则 ====================

-- 0.90 0.90：主应用
add_opacity("0.90 0.90", {
	"^(neovide)$",
	"^(localsend)$",
	"^(fdm)$",
	"^(netease-cloud-music)$",
	"^(google-chrome-stable)$",
	"^(Brave-browser)$",
	"^(com.github.rafostar.Clapper)$",
})

-- 0.80 0.80：编辑器、终端、工具类
add_opacity("0.80 0.80", {
	"^(code-oss)$",
	"^(Code)$",
	"^(code-url-handler)$",
	"^(code-insiders-url-handler)$",
	"^(kitty)$",
	"^(org.kde.dolphin)$",
	"^(org.kde.ark)$",
	"^(nwg-look)$",
	"^(qt5ct)$",
	"^(qt6ct)$",
	"^(kvantummanager)$",
	"^(com.github.tchx84.Flatseal)$",
	"^(hu.kramo.Cartridges)$",
	"^(com.obsproject.Studio)$",
	"^(gnome-boxes)$",
	"^(discord)$",
	"^(WebCord)$",
	"^(ArmCord)$",
	"^(app.drey.Warp)$",
	"^(net.davidotek.pupgui2)$",
	"^(yad)$",
	"^(Signal)$",
	"^(io.github.alainm23.planify)$",
	"^(io.gitlab.theevilskeleton.Upscaler)$",
	"^(com.github.unrud.VideoDownloader)$",
	"^(io.gitlab.adhami3310.Impression)$",
	"^(io.missioncenter.MissionCenter)$",
	"^(io.github.flattool.Warehouse)$",
})

-- 0.80 0.70：系统工具
add_opacity("0.80 0.70", {
	"^(org.pulseaudio.pavucontrol)$",
	"^(blueman-manager)$",
	"^(nm-applet)$",
	"^(nm-connection-editor)$",
	"^(org.kde.polkit-kde-authentication-agent-1)$",
	"^(polkit-gnome-authentication-agent-1)$",
	"^(org.freedesktop.impl.portal.desktop.gtk)$",
	"^(org.freedesktop.impl.portal.desktop.hyprland)$",
})

-- 0.70 0.70：游戏与音乐
add_opacity("0.70 0.70", {
	"^([Ss]team)$",
	"^(steamwebhelper)$",
	"^(Spotify)$",
})

-- Spotify 的初始标题单独处理（class + title 组合）
hl.window_rule({
	match = { class = "^(Spotify)$", title = "^(Spotify Free)$" },
	opacity = "0.70 0.70",
})

-- ==================== 浮动窗口规则 ====================

-- 带 title 的浮动规则
add_float({
	{ class = "^(org.kde.dolphin)$", title = "^(Progress Dialog — Dolphin)$" },
	{ class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" },
	{ title = "^(About Mozilla Firefox)$" },
	{ class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
	{ class = "^(firefox)$", title = "^(Library)$" },
	{ class = "^(kitty)$", title = "^(top)$" },
	{ class = "^(kitty)$", title = "^(btop)$" },
	{ class = "^(kitty)$", title = "^(htop)$" },
})

-- 仅按 class 的浮动规则
add_float({
	{ class = "^(vlc)$" },
	{ class = "^(kvantummanager)$" },
	{ class = "^(qt5ct)$" },
	{ class = "^(qt6ct)$" },
	{ class = "^(nwg-look)$" },
	{ class = "^(org.kde.ark)$" },
	{ class = "^(org.pulseaudio.pavucontrol)$" },
	{ class = "^(blueman-manager)$" },
	{ class = "^(nm-applet)$" },
	{ class = "^(nm-connection-editor)$" },
	{ class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
	{ class = "^(Signal)$" },
	{ class = "^(com.github.rafostar.Clapper)$" },
	{ class = "^(app.drey.Warp)$" },
	{ class = "^(net.davidotek.pupgui2)$" },
	{ class = "^(yad)$" },
	{ class = "^(eog)$" },
	{ class = "^(io.github.alainm23.planify)$" },
	{ class = "^(io.gitlab.theevilskeleton.Upscaler)$" },
	{ class = "^(com.github.unrud.VideoDownloader)$" },
	{ class = "^(io.gitlab.adhami3310.Impression)$" },
	{ class = "^(io.missioncenter.MissionCenter)$" },
	{ class = "^(qimgv)$" },
	{ class = "^(swayimg)$" },
})

-- ==================== 层规则 ====================

local layer_rules = {
	{ "rofi", { blur = true, ignorezero = true } },
	{ "notifications", { blur = true, ignorezero = true } },
	{ "swaync-notification-window", { blur = true, ignorezero = true } },
	{ "swaync-control-center", { blur = true, ignorezero = true } },
	{ "logout_dialog", { blur = true } },
	{ "dmenu", { blur = true, ignorealpha = 0 } },
	{ "wofi", { blur = true, ignorealpha = 0 } },
	{ "vicinae", { blur = true, ignorealpha = 0, noanim = true } },
	{ "quickshell", { blur = true, ignorealpha = 0, noanim = true } },
	{ "dms", { blur = true, ignorealpha = 0, noanim = true } },
}

for _, rule in ipairs(layer_rules) do
	local namespace, props = rule[1], rule[2]
	hl.layer_rule({
		match = { namespace = namespace },
		blur = props.blur,
		ignorezero = props.ignorezero,
		ignorealpha = props.ignorealpha,
		noanim = props.noanim,
	})
end
