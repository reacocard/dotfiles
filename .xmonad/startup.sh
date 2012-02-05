#!/bin/zsh

dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval `$dbuslaunch --sh-syntax --exit-with-session`
fi

sshagent="`which ssh-agent 2>/dev/null`"
if [ -n "$sshagent" ] && [ -x "$sshagent" ] && [ -z "$SSH_AUTH_SOCK" ]; then
    eval `$sshagent`
fi


xsetroot -cursor_name left_ptr
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --tint 0x000000 --height 12 &

run-dir ~/.autostart &

exec xmonad
