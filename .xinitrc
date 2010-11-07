#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

# xrdb -merge .Xresources

# Autorun systemwide xinit scripts. Needed on some distros.
if [ -d /etc/X11/xinit/xinitrc.d/ ]; then
    for f in /etc/X11/xinit/xinitrc.d/* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

DISPLAY="" dropboxd &

nitrogen --restore &

volcontrold.py &

SESSION=$1

if [ -z $SESSION ]; then
    SESSION=xmonad
fi

BIN=""
WRAP=ck-launch-session

case $SESSION in
    openbox)
        BIN=openbox-session
        ;;
    xmonad)
        BIN=~/.xmonad/startup.sh
        ;;
    *)
        BIN=$SESSION
        ;;
esac

exec $WRAP $BIN
