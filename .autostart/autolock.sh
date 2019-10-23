#!/bin/zsh

LOCK_TIME="${REACOCARD_SCREEN_LOCK_TIME:-1800}"
CYCLE_TIME="${REACOCARD_SCREEN_LOCK_CYCLE_TIME:-15}"  # aka notifier timeout
LOCK_CMD="${REACOCARD_SCREEN_LOCK_COMMAND:-xsecurelock}"
DIMMER="/usr/libexec/xsecurelock/dimmer"

xset s ${LOCK_TIME} ${CYCLE_TIME}
xset dpms ${LOCK_TIME} ${LOCK_TIME} ${LOCK_TIME} 

# X11 blank after lock.
export XSECURELOCK_BLANK_TIMEOUT=5
export XSECURELOCK_WAIT_TIME_MS=${CYCLE_TIME}000

exec xss-lock --notifier=${DIMMER} --transfer-sleep-lock -- ${LOCK_CMD}
