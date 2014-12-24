#!/bin/zsh

if [ -e /usr/bin/start-pulseaudio-x11 ]; then
	exec /usr/bin/start-pulseaudio-x11
fi
