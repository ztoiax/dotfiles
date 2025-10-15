function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.modified or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
end

-- 在状态栏中显示文件的用户/组
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line {}
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	}
end, 500, Status.RIGHT)

-- DDS功能，跨实例复制
-- require("session"):setup {
-- 	sync_yanked = true,
-- }

-- plugins

-- git status
require("git"):setup()

-- 边框
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

-- 修改压缩文件
require("archivemount"):setup()

-- duckdb
require("duckdb"):setup()

-- fr插件
require("fr"):setup({
	fzf = [[--info-command='echo -e "$FZF_INFO 💛"' --no-scrollbar]],
	bat = "--style 'header,grid'",
	rg = {
		"--no-heading",
		"--with-filename",
		"--line-number",
		"--column",
		"--smart-case",
		"--trim",
		"--max-depth",
		"3",
		"--no-ignore",
	},
	rga = {
		"--follow",
		"--hidden",
		"--no-ignore",
		"--glob",
		"'!.git'",
		"--glob",
		"!'.venv'",
		"--glob",
		"'!node_modules'",
		"--glob",
		"'!.history'",
		"--glob",
		"'!.Rproj.user'",
		"--glob",
		"'!.ipynb_checkpoints'",
	},
	rga_preview = {
		"--colors 'line:fg:red'"
			.. " --colors 'match:fg:blue'"
			.. " --colors 'match:bg:black'"
			.. " --colors 'match:style:nobold'",
	},
})

-- spot插件。AminurAlam/yazi-plugins:spot
require('spot'):setup {
  height = 20,
  width = 60,
  render_metadata = true,
  render_plugins = false,
}
