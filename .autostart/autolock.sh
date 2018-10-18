#!/bin/zsh

LOCK_TIME="${REACOCARD_SCREEN_LOCK_TIME:-1800}"
LOCK_CMD="${REACOCARD_SCREEN_LOCK_COMMAND:-xsecurelock}"
DIMMER="/usr/lib/x86_64-linux-gnu/xsecurelock/dimmer"

xset s ${LOCK_TIME}

# X11 blank after lock.
XSECURELOCK_BLANK_TIMEOUT=5

exec xss-lock --notifier=${DIMMER} --transfer-sleep-lock -- ${LOCK_CMD}
