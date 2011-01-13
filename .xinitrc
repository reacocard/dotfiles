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

PATH="$HOME/bin:$PATH"

dropboxd &

nitrogen --restore &

volcontrold.py &

SESSION=$1

if [ -z $SESSION ]; then
    SESSION=xmonad
fi

command=""

case $SESSION in
    openbox)
        command=openbox-session
        ;;
    xmonad)
        command=~/.xmonad/startup.sh
        ;;
    *)
        command=$SESSION
        ;;
esac

if [ -d ~/.xinitrc.d/ ]; then
    for f in ~/.xinitrc.d/* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi
exec $command
