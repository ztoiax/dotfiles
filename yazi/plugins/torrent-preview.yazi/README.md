# torrent-preview.yazi

[Yazi](https://github.com/sxyazi/yazi) plugin to preview `application/x-bittorrent` files

![show case](https://github.com/kirasok/torrent-preview.yazi/assets/75790517/6f215e6d-bb19-46f4-b606-9241594028ff)

## Requirements

- [yazi](https://github.com/sxyazi/yazi)
- [transmission-cli](https://github.com/transmission/transmission)

## Installation

### Linux/MacOS

```sh
git clone https://github.com/kirasok/torrent-preview.yazi.git ~/.config/yazi/plugins/torrent-preview.yazi
```

## Usage

Add this to your `yazi.toml`:

```toml
[[plugin.prepend_previewers]]
mime = "application/x-bittorrent"
run = "torrent-preview"
```
