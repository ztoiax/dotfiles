# ranger

## add preview_images_method mpv

- add mpv class

```sh
cat >> /usr/lib/python3.9/site-packages/ranger/ext/img_display.py << "EOF"

@register_image_displayer("mpv")
class MPVImageDisplayer(ImageDisplayer):
    def _launch_mpv(self, path):
        Popen([
            * os.environ.get("MPV", "mpv").split(),
            "--no-terminal",
            path,
        ])

    def draw(self, path, start_x, start_y, width, height):
        self._launch_mpv(path)
EOF
```

- rc.conf

```
set preview_images_method mpv
```

# qtile

## command

- [官方文档](https://github.com/qtile/qtile/blob/1f378e8ab0a820bf0cfa5dafa2ade9a3df4e942e/docs/manual/commands/shell/qtile-cmd.rst)

## debug with Xephyr

```sh
# 启动xwindow
Xephyr -br -ac -noreset -screen 800x600 :1 &

# 启动qtile
DISPLAY=:1 qtile start &

# 启动st终端
DISPLAY=:1 st &
```

