#!/bin/bash

eval `dbus-launch --sh-syntax --exit-with-session`
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "clear mod3"
xmodmap -e "add Mod3 = Caps_Lock"
xsetroot -cursor_name left_ptr
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x000000 --height 12 &
wicd-client &
blueman-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

exec xmonad
