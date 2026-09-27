// clipboard-play.js - ES5 兼容版本
// 用法：在 input.conf 中添加
//   Ctrl+v  script-message clipboard-play

(function () {
    "use strict";

    function runSubprocess(args) {
        try {
            var result = mp.command_native({
                name: "subprocess",
                args: args,
                playback_only: false,
                capture_stdout: true,
                capture_stderr: true
            });
            if (result && result.status === 0) {
                return result.stdout;
            }
        } catch (e) {
            mp.msg.warn("clipboard-play: subprocess failed: " + e);
        }
        return null;
    }

    function getClipboardText() {
        // 按顺序尝试各种剪贴板工具，兼容 Wayland / X11 / macOS / Windows
        var candidates = [
            ["wl-paste", "--no-newline"],
            ["xclip", "-selection", "clipboard", "-o"],
            ["xsel", "--clipboard", "--output"],
            ["pbpaste"],
            ["powershell", "-NoProfile", "-Command", "Get-Clipboard -Raw"]
        ];

        var i;
        for (i = 0; i < candidates.length; i++) {
            var out = runSubprocess(candidates[i]);
            if (out !== null && out.length > 0) {
                return out;
            }
        }
        return "";
    }

    function processPlaylist(text) {
        if (!text || text.length === 0) {
            mp.osd_message("剪贴板为空或读取失败");
            return;
        }

        // 按换行拆分，支持多行粘贴（B站合集、多个链接等）
        var raw = text.split(/\r?\n/);
        var items = [];
        var i;
        for (i = 0; i < raw.length; i++) {
            var line = raw[i].trim();
            // 去掉首尾引号
            if (line.length > 1) {
                var first = line.charAt(0);
                var last = line.charAt(line.length - 1);
                if ((first === '"' && last === '"') ||
                    (first === "'" && last === "'")) {
                    line = line.substring(1, line.length - 1).trim();
                }
            }
            if (line.length > 0) {
                // 反斜杠统一为正斜杠（Windows 路径兼容）
                items.push(line.replace(/\\/g, "/"));
            }
        }

        if (items.length === 0) {
            mp.osd_message("剪贴板为空");
            return;
        }

        // 第一项立即播放，其余加入播放列表
        for (i = 0; i < items.length; i++) {
            var action = (i === 0) ? "replace" : "append";
            mp.commandv("loadfile", items[i], action);
        }
        mp.osd_message("播放: " + items[0]);
    }

    mp.register_script_message("clipboard-play", function () {
        var text = getClipboardText();
        processPlaylist(text);
    });
})();
