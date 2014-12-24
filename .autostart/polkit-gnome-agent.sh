#!/bin/zsh

PATHS='/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1'

for path in $PATHS; do
    if [ -x "$path" ]; then
        exec $path
    fi
done
