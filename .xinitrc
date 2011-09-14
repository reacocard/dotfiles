#!/usr/bin/env bash

nitrogen --restore &

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

exec $command
