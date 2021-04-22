# ranger

## add preview_images_method mpv

- add mpv class

```sh
cat >> /usr/lib/python3.9/site-packages/ranger/ext/img_display.py << "EOF"

@register_image_displayer("mpv")
class MPVImageDisplayer(ImageDisplayer):
    def _launch_mpv(self, path):
        proc = Popen([
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
