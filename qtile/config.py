# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile import qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord, Mouse, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
alt = "mod1"
# terminal = guess_terminal()
terminal = "st"

import os
home = os.path.expanduser('~')

def window_to_next_group(qtile):
    """Swithcs the actual window to the next group"""
    group_names = [x.name for x in qtile.groups]
    current_group = qtile.current_group.name
    next_group = qtile.groups[(group_names.index(current_group) + 1) % len(group_names)]
    qtile.current_window.cmd_togroup(next_group.name)
    # qtile.current_screen.toggle_group(next_group)


def window_to_prev_group(qtile):
    """Swithcs the actual window to the previous group"""
    group_names = [x.name for x in qtile.groups]
    current_group = qtile.current_group.name
    next_group = qtile.groups[(group_names.index(current_group) - 1) % len(group_names)]
    qtile.current_window.cmd_togroup(next_group.name)
    # qtile.current_screen.toggle_group(next_group)

keys = [
    # Switch between windows
    Key([mod], "h",     lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l",     lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Left",  lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down",  lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up",    lazy.layout.up(), desc="Move focus up"),

    Key([mod], "j", lazy.layout.next()),
    Key([mod], "k", lazy.layout.previous()),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod], "a", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod], "d", lazy.layout.shuffle_right(), desc="Move window to the right"),

    Key([mod,], "Tab", lazy.layout.swap_column_left()),
    Key([mod, "shift"], "Tab", lazy.screen.toggle_group()),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "shift"], "h",     lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "l",     lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "Left",  lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "Down",  lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "shift"], "Up",    lazy.layout.grow_up(), desc="Grow window up"),

    Key([mod, "shift"], "j", lazy.function(window_to_next_group)),
    Key([mod, "shift"], "k", lazy.function(window_to_prev_group)),

    # Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "n", lazy.screen.next_group()),
    Key([mod], "p", lazy.screen.prev_group()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "e", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "e", lazy.prev_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "w", lazy.layout.Max(), desc="full layouts"),
    Key([mod], "o", lazy.window.toggle_fullscreen(), desc="full layouts"),
    Key([mod, "shift"], "o", lazy.window.toggle_floating(), desc="full layouts"),

    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    ##### Spawn #####
    Key(["control"], "Return", lazy.spawn("adb shell input keyevent 26")),
    Key([alt, "control"], "n", lazy.spawn("feh --bg-fill --randomize ~/Pictures/wallpapers/*")),
    # Key([alt, "control"], "a", lazy.spawn("")),

    Key([alt, "control"], "Left",  lazy.spawn("xrandr --output HDMI-0 --rotate left")),
    Key([alt, "control"], "Right", lazy.spawn("xrandr --output HDMI-0 --rotate right")),
    Key([alt, "control"], "Up",    lazy.spawn("xrandr --output HDMI-0 --rotate normal")),
    Key([alt, "control"], "Down",  lazy.spawn("xrandr --output HDMI-0 --rotate inverted")),

    Key([alt], "n", lazy.spawn("amixer set Master 5db-")),
    Key([alt], "m", lazy.spawn("amixer set Master 5db+")),

    Key([alt], "space", lazy.spawn("dmenu_run")),
    Key([alt], "o", lazy.spawn(home + "/.mybin/dmenu-search.py")),
    Key([alt], "u", lazy.spawn(home + "/.mybin/dmenu-url.sh")),
    Key([alt], "f", lazy.spawn(home + "/.mybin/dmenu-checkfile.sh")),
]


groups=[]
group_names = [ "1", "2", "3", "4", "5", "6", "7", "8"]
group_labels = [ "", "", "", "", "", "", "", ""]

group_layouts = ["max","columns","columns","columns","columns","columns","columns","columns","max"]

for i in range(len(group_names)):
    groups.extend([Group(
        name=group_names[i],
        label=group_labels[i],
        layout=group_layouts[i],
        )])

groups.extend([
        Group(
            name="9",
            label="",
            layout="max",
            matches=[
            Match(wm_class=["netease-cloud-music"]),
            Match(wm_class=["xdman-Main"]),
            Match(wm_class=["qbittorrent"]),
            ]),
        Group(name="0",label=""),
 ])

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.Columns(margin=4, border_focus='#87afdf', border_width=2),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=2),
    layout.Bsp(),
    layout.Matrix(),
    layout.MonadTall(),
    layout.MonadWide(),
    layout.RatioTile(),
    layout.Tile(),
    layout.TreeTab(),
    layout.VerticalTile(),
    layout.Zoomy(),
]

widget_defaults = dict(
    # font='sans',
    font='DroidSansMono Nerd Font',
    # font='Fira Code SemiBold',
    fontsize=22,
    padding=3,
)
extension_defaults = widget_defaults.copy()

##### color ######
color = {
        'edge'        : ("#008787", "#5f5faf"),
        'transparent' : "#080808",
        'bottom'      : "#666666",
        'scroll'      : "#00af00",
        'click'       : "#af005f",
        }

##### theme ######

transparent = [
    widget.CurrentLayoutIcon(background=color['transparent'],),
    widget.GroupBox(
        fontsize=24,
        inactive=color['bottom'],
        background=color['transparent'],
        highlight_method = "block"
        ),
    widget.WindowName(background=color['transparent'],),
    widget.Sep(linewidth=2, padding=3,size_percent=100,),
    widget.WidgetBox(widgets=[
        widget.CPU(background=color['transparent'],),
        widget.Memory(background=color['transparent'],),
        # widget.SwapGraph(background=color['transparent'],),
        # widget.ThermalSensor(highlight_method='border', background=color['transparent'],),
        widget.NvidiaSensors( background=color['transparent'],),
        widget.Net(background=color['transparent'], interface='enp27s0',),
        # widget.NetGraph(background=color['transparent'], interface='enp27s0',),
        # widget.TextBox(
        #     # "",
        #     "",
        #     # "",
        #     fontsize=22,
        #     name="edge",
        #     padding=0,
        #     foreground=color['edge'][0],
        #     background=color['edge'][1],
        #     ),
        widget.HDDBusyGraph(background=color['transparent'],),
        ],
        text_closed=' ',
        text_open=' ',
        fontsize='26',
        background=color['transparent'],
        foreground=color['click'],
    ),
    widget.CheckUpdates(display_format=' :{updates} ', background=color['transparent'],),
    widget.Cmus(background=color['transparent'],),
    widget.Volume(fmt=':{} ',background=color['transparent'],foreground=color['scroll']),
    widget.Wallpaper(fmt=' ', background=color['transparent'],foreground=color['click'],),
    # widget.TaskList(highlight_method='border', background=color['transparent'],),
    widget.Clock(background=color['transparent'], format='%Y-%m-%d %H:%M'),
    widget.QuickExit(default_text='蘆 ', foreground=color['click'],),
]

screens = [
    Screen(
        top=bar.Bar(
            transparent,
            28,
            background="#000000.1", opacity=0.6
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
respect_minimize_requests = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# startup
import subprocess
from libqtile import hook

@hook.subscribe.startup_once
def autostart():
    autostart_blocking = home + '/.dwm/autostart_blocking.sh'
    subprocess.call(autostart_blocking, shell=True)
