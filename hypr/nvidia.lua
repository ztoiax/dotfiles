-- ~/.config/hypr/nvidia.lua
-- 由 nvidia.conf 转换而来
-- See https://wiki.hyprland.org/Nvidia/

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_VRR_ALLOWED", "1")
hl.env("WLR_DRM_NO_ATOMIC", "1")

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
})