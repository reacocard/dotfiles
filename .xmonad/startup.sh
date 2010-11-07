#!/bin/bash

dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval `$dbuslaunch --sh-syntax --exit-with-session`
fi


xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "clear mod3"
xmodmap -e "add Mod3 = Caps_Lock"
xsetroot -cursor_name left_ptr
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x000000 --height 12 &
wicd-client &
blueman-applet &


# TODO: This is ugly, use a loop.
POLKIT_BIN=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
if [ -x $POLKIT_BIN ]; then
    $POLKIT_BIN &
else
    POLKIT_BIN=/usr/libexec/polkit-gnome-authentication-agent-1
    if [ -x $POLKIT_BIN ]; then
        $POLKIT_BIN &
    fi
fi

exec xmonad
