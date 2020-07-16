#!/bin/sh

if [ x"$XDG_CURRENT_DESKTOP" = x"GNOME" ]; then
    DCONF_KEY='/org/gnome/desktop/peripherals/touchpad/send-events'
    current=`dconf read $DCONF_KEY`
    if [ x"$current" = x"'enabled'" ]; then
        dconf write $DCONF_KEY "'disabled'"
    else
        dconf write $DCONF_KEY "'enabled'"
    fi
else
    synclient TouchpadOff=$(expr 1 - $(synclient -l | grep TouchpadOff | cut -b 31))
fi
