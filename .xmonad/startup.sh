#!/bin/zsh

# Make sure xdg-open doesn't misdetect.
export XDG_CURRENT_DESKTOP=X-Generic

dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval `$dbuslaunch --sh-syntax --exit-with-session`
fi

systemd_ssh_agent_sock="${XDG_RUNTIME_DIR}/ssh-agent.socket"
if [ -e "$systemd_ssh_agent_sock" ]; then
    export SSH_AUTH_SOCK="$systemd_ssh_agent_sock"
else
    sshagent="`which ssh-agent 2>/dev/null`"
    if [ -n "$sshagent" ] && [ -x "$sshagent" ] && [ -z "$SSH_AUTH_SOCK" ]; then
        eval `$sshagent`
    fi
fi

setxkbmap -option caps:hyper
xsetroot -cursor_name left_ptr
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --tint 0x000000 --height 26 &

run-dir ~/.autostart &

exec xmonad
